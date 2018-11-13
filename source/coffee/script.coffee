jQuery(document).ready ($) ->
	body = $('body')
	main = $('main')
	sectionTitles = $('.section-titles')
	archive = $('#archive')
	lightbox = $('#lightbox')
	lightboxMedia = $('#lightbox-media')
	desktopHeader = $('header.desktop')
	mobileHeader = $('header.mobile')
	footer = $('footer')

	MIN_VOL = 0
	MAX_VOL = 0.8
	OVERLAY_DUR = 200
	SCROLL_DUR = 500
	PADDING = 30

	selectChapter = (e) ->
		e.preventDefault()
		id = $(this).data('id')
		title = $(this).data('title')
		href = this.href
		history.pushState(null, null, href);
		top = main.position().top
		$('html, body').animate
			scrollTop: top
		, SCROLL_DUR
		if main.data('id') == id
			return
		main.addClass('loading').data('id', id)
		chaperTitle = $('<a class="chapter-title" href="'+href+'"><h3>'+title+'</h3></a>')
		desktopHeader.find('.header-titles').append(chaperTitle)
		openChapter(id)

	openChapter = (id) ->
		$.ajax
			url: ajax_obj.ajaxurl,
			type: 'POST',
			dataType: 'html',
			data:
				action: 'get_chapter',
				id: id
			success: (response) ->
				main.append response
				main.removeClass('loading').addClass('loaded')
				prepareBlocks()
			error: (jqXHR, textStatus, errorThrown) ->
				console.log jqXHR, textStatus, errorThrown

	prepareBlocks = () ->
		blocks = $('.blocks')
		blocks.find('.section-title').each (i, block) ->
			title = $(block).find('.section-title-text').text()	
			if title
				slug = slugify(title)
				$(block).attr('id', slug)
				titleHtml = $('<h5 class="section-title"></h5>')
					.attr('data-slug', slug)
					.html('<a href="#'+slug+'" class="section-anchor">'+title+'</a>')
				sectionTitles.append(titleHtml)
		blocks.find('.media-block').each (i, block) ->
			if $(block).is('.full-media-block')
				blockBody = $(block).find('.block-body')
				if !blockBody.text()
					blockBody.remove()
		blocks.imagesLoaded()
			.done () ->
				if hash = window.location.hash
					scrollToSection(hash, false)
				$(window).on 'scroll', onScroll
				blocks.addClass('loaded')
				onScroll()

	selectSection = (e) ->
		e.preventDefault()
		hash = e.target.hash
		history.pushState(null, null, hash);
		scrollToSection(hash, true)

	scrollToSection = (hash, animate) ->
		id = decodeURIComponent(hash)
		title = $('.section-title'+id)
		if title.length
			top = title.position().top
			if desktopHeader.css('display') != 'none'
				top -= desktopHeader.innerHeight()+1
			if animate
				$('html, body').animate
					scrollTop: top
				, SCROLL_DUR
			else
				$('html, body').scrollTop(top)
		else
			$('html, body').scrollTop(0)
		if id == '#archive'
			toggleArchive()
				

	setupSlideshows = () ->
		$('.block-media.slideshow').each (i, block) ->
			maxHeight = 0
			block = $(block)
			block.imagesLoaded()
				.progress (inst, image) ->
					img = image.img
					media = $(img).parent()
					if img.naturalHeight > maxHeight
						maxHeight = img.naturalHeight
						block.find('.static').removeClass('static')
						block.attr('data-ratio', img.naturalHeight/img.naturalWidth)
						media.addClass('static')
				.done (inst) ->
					$(window).resize()
			setInterval () ->
				activeMedia = block.find('.active')
				if activeMedia.length
					nextMedia = block.find('.active').next('.media')
				if !nextMedia || !nextMedia.length
					nextMedia = block.find('.media').first()
				block.find('.active').removeClass('active')
				nextMedia.addClass('active')
			, 5000


	toggleArchive = (e) ->
		if body.is('.open-archive')
			closeArchive()
			e.preventDefault()
		else
			openArchive()
			
	openArchive = () ->
		muteVideos()
		body.addClass('open-archive no-scroll')

	closeArchive = () ->
		body.removeClass('open-archive no-scroll')
		url = window.location.href.split('#')[0]
		history.pushState(null, null, url)
		$(window).scroll()

	openLightbox = (e) ->
		media = $(this)
		lightboxMedia = $('#lightbox-media')
		if media.find('img').length
			img = media.find('img')
			src = img.attr('src')
			lightboxMedia.css
				backgroundImage: 'url('+src+')'
		else if media.find('video').length
			video = media.find('video')[0]
			cloneVideo = $(video).clone()[0]
			lightboxMedia.append cloneVideo
			cloneVideo.currentTime = video.currentTime
			cloneVideo.volume = MAX_VOL
			cloneVideo.muted = false
			cloneVideo.play()
		else if media.css('background-image')
			bg = media.css('background-image')
			lightboxMedia.css
				backgroundImage: bg
		body.addClass('open-lightbox no-scroll')
		muteVideos()

	closeLightbox = (e) ->
		lightboxMedia = $('#lightbox-media')
		body.removeClass('open-lightbox no-scroll')
		setTimeout () ->
			lightboxMedia.html('').attr('style', '')
		, OVERLAY_DUR
		$(window).scroll()

	muteVideos = () ->
		$('.media-block video').each (i, video) ->
			video.volume = 0

	toggleMenu = (e) ->
		body.toggleClass('open-menu no-scroll')

	showChapterCover = (e) ->
		id = $(this).data('id')
		media = $('.media[data-id="'+id+'"]')
		if media.length
			$('.media').removeClass('show')
			media.addClass('show')

	hideChapterCover = (e) ->
		$('.media').removeClass('show')

	showTab = (e) ->
		id = $(this).data('id')
		$content = $('.tab-content[data-id="'+id+'"]')
		$('.tab, .tab-content').removeClass('active')
		$(this).addClass('active')
		$content.addClass('active')

	toggleExpander = (e) ->
		$expandWrapper = $(this).parents('.expand-wrapper')
		$expandContent = $expandWrapper.find('.expand-content')
		$expandWrapper.toggleClass('open')
		if $expandWrapper.is('.open')
			$inner = $expandWrapper.find('.expand-inner')
			innerHeight = $inner.innerHeight()
		else
			innerHeight = 0
		$expandContent.animate
			height: innerHeight
		, SCROLL_DUR, () ->
			if $expandWrapper.is('.open')
				$expandContent.css
					height: 'auto'

	onResize = (e) ->
		if footer.length
			$('.blocks-inner').css
				paddingBottom: footer.innerHeight()+PADDING
		# $('.archive-medias').masonry()
		$('.block-media.slideshow').each (i, block) ->
			block = $(block)
			if ratio = block.attr('data-ratio')
				newHeight = block.innerWidth()*ratio
				block.css
					height: newHeight+PADDING+'px'

	onKeypress = (e) ->
		if e.key == 'Escape'
			if body.is('.open-lightbox')
				closeLightbox()
			if body.is('.open-archive')
				closeArchive()

	prevScrollTop = 0		
	onScroll = (e) ->
		if body.is('.page') || body.is('.archive')
			return
		winHeight = $(window).innerHeight()
		winHalf = winHeight/2
		scrollTop = $(window).scrollTop()
		scrollBottom = winHeight + scrollTop
		scrollDir = if scrollTop > prevScrollTop then 'down' else 'up'
		mainTop = main.position().top
		if scrollTop >= mainTop
			body.addClass('in-chapter')
		else
			body.removeClass('in-chapter')
		slugs = []
		$('.block.section-title').each (i, sectionTitle) ->
			titleTop = $(sectionTitle).offset().top - desktopHeader.innerHeight()-1
			if titleTop <= scrollTop
				sectionSlug = $(sectionTitle).attr('id')
				slugs.push(sectionSlug)
		if currTitle = slugs[slugs.length-1]
			currTitleHtml = sectionTitles.find('[data-slug="'+currTitle+'"]')
			if !currTitleHtml.is('.active')
				currTitleHtml.addClass('active')
				url = currTitleHtml.find('a')[0].href
				history.pushState(null, null, url)
		else if window.location.hash.length
			history.pushState(null, null, '#')
		$('.section-title').not(currTitleHtml).removeClass('active')

		$('.media-block video').each (i, video) ->
			if !$(video).is('.init')
				$(video).addClass('init')
					.attr('loop','loop')
				video.play()
			videoHeight = $(video).innerHeight()
			videoHalf = videoHeight/2
			videoTop = $(video).offset().top
			videoMid = videoHeight/2 + videoTop
			videoBottom = $(video).innerHeight() + videoTop
			videoTopScroll = videoTop - scrollTop
			videoMidScroll = scrollTop - videoMid + winHalf
			videoBottomScroll = videoBottom - scrollTop
			if videoMidScroll >= 0
				vol = findVol(videoBottomScroll, 0, winHalf+videoHalf)
			else
				vol = findVol(videoTopScroll, winHeight, winHalf-videoHalf)
			video.volume = vol
		prevScrollTop = scrollTop

	findVol = (videoPos, scrollMin, scrollMax) ->
		volMin = MIN_VOL
		volMax = MAX_VOL
		vol = (videoPos - scrollMin) * (volMax - volMin) / (scrollMax - scrollMin) + volMin
		if vol > MAX_VOL then vol = MAX_VOL
		if vol < MIN_VOL then vol = MIN_VOL
		return vol

	slugify = (str) ->
		slug = str.toString().toLowerCase()
			.replace(/\s+/g, '-')
			.replace(/\-\-+/g, '-')
			.replace(/^-+/, '')
			.replace(/-+$/, '')
		return slug

	# $('.archive-medias').masonry
	# 	itemSelector: '.archive-media',
	# 	columnWidth: '.col',
	# 	transitionDuration: 0

	# $('.archive-medias img').each (i, img) ->
	# 	img.onload = () ->
	# 		$('.archive-medias').masonry()

	# $('.archive-medias video').each (i, video) ->
	# 	$(video).on 'loadeddata', () ->
	# 		$('.archive-medias').masonry()

	$('body').on 'vclick', '.archive-toggle', toggleArchive
	$('body').on 'vclick', '.menu-toggle', toggleMenu
	$('body').on 'mouseenter', '.chapter-square:not(.show)', showChapterCover
	$('body').on 'mouseleave', '.chapter-square', hideChapterCover
	$('body').on 'vclick', '.tabs .tab:not(.active)', showTab
	$('body').on 'vclick', '.expand-toggle', toggleExpander
	$('body').on 'vclick', '.section-anchor', selectSection
	$('body').on 'vclick', 'a.chapter-square', selectChapter
	$('body').on 'vclick', '.block-media', openLightbox
	$('body').on 'vclick', '.lightbox-close, #lightbox-media', closeLightbox
	$('body').on 'keyup', onKeypress
	$(window).on 'resize', onResize
	$(window).on 'load', () ->
		prepareBlocks()
		setupSlideshows()
	onResize()
