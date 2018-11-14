jQuery(document).ready ($) ->
	body = $('body')
	main = $('main')
	sectionTitles = $('.section-titles')
	archive = $('#archive')
	archiveMedia = $('.archive-medias')
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
		url = this.href
		chapterTitle = desktopHeader.find('.chapter-title')
		history.pushState(null, null, url);
		top = main.position().top
		$('html, body').animate
			scrollTop: top
		, SCROLL_DUR
		if main.data('id') == id
			return
		main.addClass('loading').data('id', id).data('url', url)
		chapterTitle.attr('href', url).find('h3').html(title)
		# chaperTitle = $('<a class="chapter-title" href="'+url+'"><h3>'+title+'</h3></a>')
		# desktopHeader.find('.header-titles').append(chaperTitle)
		openChapter(id)

	openChapter = (id) ->
		main.removeClass('loaded').addClass('loading')
		$.ajax
			url: ajax_obj.ajaxurl,
			type: 'POST',
			dataType: 'html',
			data:
				action: 'get_chapter',
				id: id
			success: (response) ->
				main.html(response)
				main.removeClass('loading').addClass('loaded')
				prepareBlocks()
			error: (jqXHR, textStatus, errorThrown) ->
				console.log jqXHR, textStatus, errorThrown

	prepareBlocks = () ->
		blocks = $('.blocks')
		sectionTitles.html('')
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

		blocks.find('video').each (i, video) ->
			video.loop = true
			video.autoplay = true
			video.muted = true
			block = $(video).parent()
			block.addClass('muted')
			$(video).attr('muted','muted')
			video.play()
			body.one 'vclick', () ->
				video.muted = false
				$(video).attr('muted','')
				block.removeClass('muted')
				
	prepareArchive = () ->
		archiveMedia.masonry
			itemSelector: '.col',
			transitionDuration: 0

		archiveMedia.masonry 'on', 'layoutComplete', () ->
		  archiveMedia.addClass('masonry')

		archiveMedia.find('.block-media').each (i, block) ->
			if $(block).find('img').length
				$(block).find('img')[0].onload = () ->
					if archiveMedia.is('.masonry')
						archiveMedia.masonry()
			else if $(block).find('img').length
				$(block).find('video')[0].on 'loadeddata', () ->
					if archiveMedia.is('.masonry')
						archiveMedia.masonry()

	selectSection = (e) ->
		e.preventDefault()
		hash = e.target.hash
		history.pushState(null, null, hash);
		scrollToSection(hash, true)

	scrollToSection = (hash, animate) ->
		hash = decodeURIComponent(hash)
		title = $('.section-title'+hash)
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
		if hash.includes('#archive')
			toggleArchive()
			index = parseInt(hash.split('-')[1])
			if !Number.isInteger(index)
				return
			if media = $(archiveMedia.find('.archive-media')[index-1])
				openLightbox(media)
				

	prepareSlideshows = () ->
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
		sectionTitles.find('.active').removeClass('active')
		body.addClass('open-archive no-scroll')

	closeArchive = () ->
		body.removeClass('open-archive no-scroll')
		url = window.location.href.split('#')[0]
		history.pushState(null, null, url)
		$(window).scroll()

	selectMedia = (e) ->
		media = $(this)
		openLightbox(media)

	openLightbox = (media) ->
		if !media.length || media.find('.muted').length
			return
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

		if body.hasClass('open-archive')
			url = window.location.href.split('#')[0]
			history.pushState(null, null, url+'#archive')

		setTimeout () ->
			lightboxMedia.html('').attr('style', '')
		, OVERLAY_DUR
		$(window).scroll()

	unmuteVideos = () ->
		$('.media-block video').each (i, video) ->
			video.muted = false
			video.play()

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
		$('.block-media.slideshow').each (i, block) ->
			block = $(block)
			if ratio = block.attr('data-ratio')
				newHeight = block.innerWidth()*ratio
				block.css
					height: newHeight+PADDING+'px'

		if archiveMedia.is('.masonry')
			archiveMedia.masonry()


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
		chapterUrl = main.data('url')
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
				sectionHash = currTitleHtml.find('a').attr('href')
				if !body.is('.open-archive') && !body.is('.open-lightbox')
					history.pushState(null, null, chapterUrl+sectionHash)
		else if window.location.hash.length
			if !body.is('.open-archive') && !body.is('.open-lightbox')
				history.pushState(null, null, '#')
		$('.section-title').not(currTitleHtml).removeClass('active')

		$('.media-block video').each (i, video) ->
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
			if !video.playing
				playPromise = video.play()
				if (playPromise != undefined)
					playPromise.then () ->
						$(video).attr('muted','')
					.catch (error) ->
						console.log error
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

	

	body.on 'vclick', '.archive-toggle', toggleArchive
	body.on 'vclick', '.menu-toggle', toggleMenu
	body.on 'mouseenter', '.chapter-square:not(.show)', showChapterCover
	body.on 'mouseleave', '.chapter-square', hideChapterCover
	body.on 'vclick', '.tabs .tab:not(.active)', showTab
	body.on 'vclick', '.expand-toggle', toggleExpander
	body.on 'vclick', '.section-anchor', selectSection
	body.on 'vclick', 'a.chapter-square', selectChapter
	body.on 'vclick', '.block-media', selectMedia
	body.on 'vclick', '.lightbox-close, #lightbox-media', closeLightbox
	body.on 'keyup', onKeypress
	$(window).on 'resize', onResize
	$(window).on 'load', () ->
		prepareBlocks()
		prepareSlideshows()
		prepareArchive()
	onResize()
