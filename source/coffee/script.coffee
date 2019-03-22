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

	isMobile = () ->
		check = ['"\"mobile\""', '"mobile"', 'mobile']
		if check.includes body.css('content')
			return true
		else
			return false

	# prepareIntro = () ->
	# 	$('.chapter-square').each (i, square) ->
	# 		setTimeout () ->
	# 			$(square).addClass('show')
	# 		, (i+1)*500


	selectChapter = (e) ->
		e.preventDefault()
		e.stopPropagation()
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
		openChapter(id)
		return false

	openChapter = (id) ->
		main.removeClass('loaded').addClass('loading')
		url = SiteSettings.url.api+'chapter/'+id
		$.ajax
			url: url,
			type: 'GET',
			dataType: 'html',
			success: (response) ->
				console.log(response)
				main.html(response)
				main.removeClass('loading').addClass('loaded')
				prepareBlocks()
			error: (jqXHR, textStatus, errorThrown) ->
				console.log jqXHR, textStatus, errorThrown

	prepareBlocks = () ->
		blocks = $('.blocks')
		console.log(blocks)
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
			if $(block).is('.full-media-block') || $(block).is('.center-media-block')
				blockBody = $(block).find('.block-body')
				if blockBody.text()
					return
				if blockBody.parents('.block-text').length
					blockBody.parents('.block-text').remove()
				blockBody.remove()

		blocks.find('video').each (i, video) ->
			block = $(video).parent()	
			block.append($('<div class="btn"></div>'))
			if isMobile()
				video.autoplay = false
				video.muted = false
				video.volume = 1
				return
			else
				video.autoplay = true
				block.addClass('muted mutable')
				playPromise = video.play()
				if playPromise != undefined
					playPromise.then () ->
						$(video).on 'timeupdate', () ->
							video = this
							media = $(video).parent('.media')
							if !video.paused
								media.removeClass('muted')
								$(video).off 'timeupdate'
							else
								media.addClass('muted')
					.catch (error) ->
						console.log error

		blocks.imagesLoaded()
			.always () ->
				if hash = window.location.hash
					scrollToSection(hash, false)
				$(window).on 'scroll', onScroll
				blocks.addClass('loaded')
				onScroll()
				
	prepareArchive = () ->
		archiveMedia.masonry
			itemSelector: '.col',
			transitionDuration: 0

		archiveMedia.masonry 'on', 'layoutComplete', () ->
		  archiveMedia.addClass('masonry')

		archiveMedia.find('.block-media').each (i, block) ->
			video = $(block).find('video')
			if $(block).find('img').length
				$(block).find('img')[0].onload = () ->
					if archiveMedia.is('.masonry')
						archiveMedia.masonry()
			else if video.length
				if isMobile()
					video[0].controls = true
				else
					video[0].controls = false
					$(block).addClass('paused')
				$(block).find('video').on 'loadeddata', () ->
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

	clickInlineLink = (e) ->
		hash = e.target.hash
		media = $(hash)
		if !hash || !media || !media.length
			return
		e.preventDefault()
		e.stopPropagation()
		openLightbox(media)

	toggleArchive = (e) ->
		if e
			e.stopPropagation()
		if body.is('.open-archive')
			closeArchive()
			if e
				e.preventDefault()
		else
			openArchive()
			
	openArchive = () ->
		muteVideos()
		sectionTitles.find('.active').removeClass('active')
		body.addClass('open-archive no-scroll')
		archiveMedia.masonry()

	closeArchive = () ->
		body.removeClass('open-archive no-scroll')
		url = window.location.href.split('#')[0]
		history.pushState(null, null, url)
		$(window).scroll()

	selectMedia = (e) ->
		media = $(this)
		video = media.find('video')
		if isMobile() && video.length
			if video[0].paused
				video[0].play()
			else
				video[0].pause()
			return
		if media.find('.muted').length || $(e.target).is('.btn')
			return
		openLightbox(media)

	openLightbox = (media) ->
		if !media.length
			return
		lightboxMedia = $('#lightbox-media')
		if media.find('object').length
			object = media.find('object')[0]
			cloneObject = $(object).clone()[0]
			lightboxMedia.append cloneObject
		else if media.find('img').length
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
		if isMobile()
			return
		$('.media-block video').each (i, video) ->
			video.muted = false
			video.play()

	muteVideos = () ->
		if isMobile()
			return
		$('.media-block video').each (i, video) ->
			video.volume = 0

	toggleMute = () ->
		media = $(this).parents('.media')
		video = $(media).find('video')
		media.toggleClass('muted')
		video[0].muted = media.is('.muted')
		$(window).scroll()

	toggleMenu = (e) ->
		e.preventDefault()
		e.stopPropagation()
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
		e.preventDefault()
		e.stopPropagation()
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
		showArchive = archive.offset().top <= scrollTop + winHeight
		if scrollTop >= mainTop
			body.addClass('in-chapter')
		else
			body.removeClass('in-chapter')

		if showArchive
			body.addClass('show-archive')
			$('.section-title').removeClass('active')
		else
			body.removeClass('show-archive')
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

		archiveMedia.find('.block-media video').each (i, video) ->
			if isMobile()
				video.controls = true
			else
				video.controls = false
				$(video).parents('.block').addClass('paused')
		
		$('.media-block video').each (i, video) ->
			media = $(video).parents('.media')
			media.removeClass('paused')
			if isMobile()
				media.removeClass('muted')
				video.controls = true
				video.autoplay = false
				video.muted = false
				video.volume = 1
				return
			else
				video.controls = false
				video.autoplay = true
			videoHeight = $(video).innerHeight()
			videoHalf = videoHeight/2
			videoTop = $(video).offset().top
			videoMid = videoHeight/2 + videoTop
			videoBottom = $(video).innerHeight() + videoTop
			videoTopScroll = videoTop - scrollTop
			videoMidScroll = scrollTop - videoMid + winHalf
			videoBottomScroll = videoBottom - scrollTop

			if media.is('.muted')
				vol = 0
			else if videoMidScroll >= 0
				vol = findVol(videoBottomScroll, 0, winHalf+videoHalf)
			else
				vol = findVol(videoTopScroll, winHeight, winHalf-videoHalf)
			video.volume = vol
			playPromise = video.play()
			if playPromise != undefined
				playPromise.then () ->
					if vol > 0
						$(video).addClass('play')
						video.muted = false
					else
						$(video).removeClass('play')
				.catch (error) ->
					console.log error.message
		prevScrollTop = scrollTop

	onClick = () ->
		if isMobile()
			return
		$('.media-block video').each (i, video) ->
			video.play()

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

	body.on 'vclick', '.body-text a', clickInlineLink
	body.on 'vclick', '.archive-toggle', toggleArchive
	body.on 'vclick', '.menu-toggle', toggleMenu
	body.on 'mouseenter', '.chapter-square:not(.show)', showChapterCover
	body.on 'mouseleave', '.chapter-square', hideChapterCover
	body.on 'vclick', '.tabs .tab:not(.active)', showTab
	body.on 'click', '.expand-toggle', toggleExpander
	body.on 'vclick', '.section-anchor', selectSection
	body.on 'click', 'a.chapter-square', selectChapter
	body.on 'click', '.block-media', selectMedia
	body.on 'click', '.mutable .btn', toggleMute
	body.on 'vclick', '.lightbox-close, #lightbox-media', closeLightbox
	body.on 'keyup', onKeypress
	body.on 'click', onClick
	$(window).on 'resize', onResize
	$(window).on 'load', () ->
		# prepareIntro()
		prepareBlocks()
		prepareSlideshows()
		prepareArchive()
	onResize()
