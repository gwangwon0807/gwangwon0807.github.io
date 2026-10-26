# 직접 쓰는 내용은 전부 _content/ 에 있음. 이 플러그인이 그걸 사이트에 연결함.
#
# 글: _content/posts/YYMMDD_주소/post.md (+ 같은 폴더의 assets/)
#   - 폴더 이름 앞 6자리가 날짜 (261015 → 2026-10-15). front matter 에 date 를 쓰면 그게 우선.
#   - 폴더 이름의 "_" 뒤가 주소 (/posts/주소/).
#   - assets/ 안 파일은 /posts/주소/assets/ 로 복사됨 → 글에서는 assets/파일.png 로 씀.
#   - 000000_ 으로 시작하는 폴더(템플릿)는 무시.
#   - front matter 에 hidden: true 면 숨김 글: 주소로만 열리고 홈, 카테고리, 태그, 검색, 피드,
#     이전/다음 글, 관련 글 어디에도 안 나옴 (글 목록에서 빼고 별도 묶음 "hidden" 으로 내보냄)
# 시리즈: front matter 에 series: 이름 → 같은 이름끼리 날짜순으로 묶어 글 맨 위에 시리즈 상자 표시
#   (상자 모양은 _includes/series.html)
# 사진: _content/ 바로 아래 이미지 파일 → /assets/me/ 로 복사 (사이드바 프로필 사진용)
# 사이트 이름: _content/sidebar.yml 의 name, tagline 을 사이트 제목/부제로도 씀
module ContentFolder
  ROOT = '_content'
  POST_FOLDER = /\A(\d{2})(\d{2})(\d{2})_(.+)\z/
  IMAGE = /\.(png|jpe?g|gif|webp|svg)\z/i

  # 원본 위치와 다른 주소로 내보내는 정적 파일
  class Asset < Jekyll::StaticFile
    def initialize(site, dir, name, dest_dir)
      super(site, site.source, dir, name)
      @dest_dir = dest_dir
    end

    def destination_rel_dir
      @dest_dir
    end

    def url
      File.join(@dest_dir, @name)
    end
  end

  # sidebar.yml 의 이름을 사이트 제목으로 (브라우저 탭, 검색 결과)
  Jekyll::Hooks.register :site, :post_read do |site|
    me = site.data['sidebar'] || {}
    site.config['title'] = me['name'] if me['name']
    site.config['tagline'] = me['tagline'] if me['tagline']
    # 테마가 글쓴이 링크, 검색엔진 정보에 social.name / social.links 를 씀 → sidebar.yml 에서 채움
    web = Array(me['links']).find { |l| l['type'] != 'email' && l['url'] }
    site.config['social'] = { 'name' => me['name'], 'links' => [web ? web['url'] : site.config['url']] }
  end

  class Generator < Jekyll::Generator
    priority :highest # 페이지 나누기, 카테고리/태그 생성보다 먼저

    def generate(site)
      root = File.join(site.source, ROOT)
      add_profile_images(site, root)
      add_posts(site, root)
      link_series(site)
    end

    private

    # 같은 series 끼리 날짜순 목록을 각 글에 넣어 둠 (숨김 글은 글 목록에 없으므로 자동 제외)
    def link_series(site)
      site.posts.docs.select { |d| d.data['series'] }.group_by { |d| d.data['series'].to_s.strip }.each_value do |docs|
        docs = docs.sort_by { |d| [d.date, d.relative_path] }
        list = docs.map { |d| { 'title' => d.data['title'], 'url' => d.url } }
        docs.each_with_index do |d, i|
          d.data['series_list'] = list
          d.data['series_index'] = i + 1
        end
      end
    end

    def add_profile_images(site, root)
      Dir.glob(File.join(root, '*')).each do |file|
        next unless File.file?(file) && file =~ IMAGE
        site.static_files << Asset.new(site, ROOT, File.basename(file), '/assets/me')
      end
    end

    def hidden_collection(site)
      site.collections['hidden'] ||= begin
        site.config['collections']['hidden'] = { 'output' => true }
        Jekyll::Collection.new(site, 'hidden')
      end
    end

    def add_posts(site, root)
      posts = site.posts
      Dir.glob(File.join(root, 'posts', '*', 'post.md')).sort.each do |path|
        # macOS 파일명은 한글이 자모 분리(NFD) + 인코딩 미지정으로 넘어옴 → UTF-8, 완성형(NFC)으로
        path = path.dup.force_encoding('UTF-8')
        dir = File.dirname(path)
        folder = File.basename(dir).unicode_normalize(:nfc)
        m = POST_FOLDER.match(folder)
        next unless m
        next if folder.start_with?('000000_')

        slug = Jekyll::Utils.slugify(m[4], mode: 'default')
        doc = Jekyll::Document.new(path, site: site, collection: posts)
        doc.read
        if doc.data['hidden'] == true
          doc = Jekyll::Document.new(path, site: site, collection: hidden_collection(site))
          doc.read
          doc.data['layout'] ||= 'post'
          doc.data['permalink'] = "/posts/#{slug}/"
          doc.data['sitemap'] = false
          # 숨김 글은 카테고리/태그 목록에 없으므로 링크가 깨짐 → 비움
          doc.data['categories'] = []
          doc.data['tags'] = []
        end
        # Jekyll 이 폴더 경로(_content, posts, 261015_주소)를 카테고리로 붙이므로 제거 → front matter 의 것만
        path_dirs = File.dirname(doc.relative_path).split('/').map { |d| d.unicode_normalize(:nfc) }
        doc.data['categories'] = Array(doc.data['categories']).reject { |c| path_dirs.include?(c.to_s.unicode_normalize(:nfc)) }
        doc.data['slug'] = slug
        doc.data['title'] = m[4] if ['', 'Post'].include?(doc.data['title'].to_s) # 제목 없으면 폴더 이름
        doc.data['date'] ||= Time.new(2000 + m[1].to_i, m[2].to_i, m[3].to_i, 0, 0, 0, '+09:00')
        doc.data['date'] = Jekyll::Utils.parse_date(doc.data['date'].to_s) unless doc.data['date'].is_a?(Time)
        doc.data['media_subpath'] ||= "/posts/#{slug}/"

        next if doc.data['published'] == false
        next if doc.data['date'] > site.time && !site.future

        doc.collection.docs << doc

        Dir.glob(File.join(dir, 'assets', '**', '*')).each do |file|
          file = file.dup.force_encoding('UTF-8')
          next if File.directory?(file) || File.basename(file).start_with?('.')
          rel_dir = File.dirname(file).delete_prefix("#{site.source}/")
          sub = File.dirname(file).delete_prefix(File.join(dir, 'assets'))
          site.static_files << Asset.new(site, rel_dir, File.basename(file), "/posts/#{slug}/assets#{sub}")
        end
      end
      posts.docs.sort!
    end
  end

  # 시리즈가 있는 글은 본문 맨 앞에 시리즈 상자를 끼워 넣음
  Jekyll::Hooks.register :posts, :pre_render do |doc|
    doc.content = "{% include series.html %}\n\n" + doc.content if doc.data['series_list']
  end
end
