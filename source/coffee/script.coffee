jQuery(document).ready ($) ->
	body = $('body')
	main = $('main')
	blocks = $('.blocks')
	sectionTitles = $('.section-titles')
	archivalMaterials = $('#archival-materials')
	desktopHeader = $('header.desktop')
	mobileHeader = $('header.mobile')

	selectChapter = (e) ->
		e.preventDefault()
		id = $(this).data('id')
		title = $(this).data('title')
		href = this.href
		history.pushState(null, null, href);
		top = main.position().top
		$('html, body').animate
			scrollTop: top
		, 500
		if main.data('id') == id
			return
		main.addClass('loading').data('id', id)
		desktopHeader.find('.chapter-title h3').html(title)
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
				getSectionTitles()
			error: (jqXHR, textStatus, errorThrown) ->
				console.log jqXHR, textStatus, errorThrown

	getSectionTitles = () ->
		$('.section-title').each (i, block) ->
			title = $(block).find('.section-title-text').text()
			if title
				slug = slugify(title)
				$(block).attr('id',slug)
				titleHtml = $('<h5 class="section-title"></h5>')
					.attr('data-title', title)
					.html('<a href="#'+slug+'" class="section-anchor">'+title+'</a>')
				sectionTitles.append(titleHtml)

	selectSection = (e) ->
		e.preventDefault()
		hash = e.target.hash
		history.pushState(null, null, hash);
		scrollToSection(hash)

	scrollToSection = (hash) ->
		if title = $('.section-title'+hash)
			top = title.position().top
			$('html, body').animate
				scrollTop: top
			, 500

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

	onResize = (e) ->
		$('.objects').masonry()
		$('.block-media.slideshow').each (i, block) ->
			block = $(block)
			if ratio = block.attr('data-ratio')
				newHeight = block.innerWidth()*ratio
				block.css
					height: newHeight+30+'px'

	toggleArchival = (e) ->
		body.toggleClass('open-archive')
		if !body.is('.open-archive')
			e.preventDefault()
			url = window.location.href.split('#')[0]
			history.pushState(null, null, url)

	toggleMenu = (e) ->
		body.toggleClass('open-menu')

	showChapterCover = (e) ->
		slug = $(this).data('slug')
		media = $('.media[data-slug="'+slug+'"]')
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
		, 500, () ->
			if $expandWrapper.is('.open')
				$expandContent.css
					height: 'auto'

	onScroll = (e) ->
		scrollTop = $(this).scrollTop() 
		scrollBottom = $(window).innerHeight() + scrollTop

		mainTop = main.position().top
		if scrollTop >= mainTop
			body.addClass('in-chapter')
		else
			body.removeClass('in-chapter')

		titles = []
		$('.block.section-title').each (i, sectionTitle) ->
			titleTop = $(sectionTitle).offset().top
			if titleTop <= scrollTop
				sectionTitleText = $(sectionTitle).find('.section-title-text').text()
				titles.push(sectionTitleText)
		if currTitle = titles[titles.length-1]
			currTitleHtml = sectionTitles.find('[data-title="'+currTitle+'"]')
			if !currTitleHtml.is('.active')
				currTitleHtml.addClass('active')
				url = currTitleHtml.find('a')[0].href
				history.pushState(null, null, url)
		else if window.location.hash.length
			history.pushState(null, null, '#')
		$('.section-title').not(currTitleHtml).removeClass('active')

		$('.media-block video').each (i, video) ->
			videoTop = $(video).offset().top
			videoBottom = $(video).innerHeight() + videoTop
			if videoTop <= scrollBottom && videoBottom >= scrollTop && video.paused
				video.play()
				if !$(video).attr('loop')
					$(video).attr('loop','loop')
				video.animate
					volume: 1,
				, 1000
			else if videoTop >= scrollBottom || videoBottom <= scrollTop && !video.paused
				video.animate
					volume: 0,
				, 1000
				setTimeout () ->
					video.pause()
				, 1000

	slugify = (str) ->
		return str.toString().toLowerCase()
			.replace(/\s+/g, '-')
			.replace(/[^\w\-]+/g, '')
			.replace(/\-\-+/g, '-')
			.replace(/^-+/, '')
			.replace(/-+$/, '')

	$('.objects').masonry
		itemSelector: '.object',
		columnWidth: '.col',
		transitionDuration: 0

	$('.objects img').each (i, img) ->
		img.onload = () ->
			$('.objects').masonry()

	$('.objects video').each (i, video) ->
		$(video).on 'loadeddata', () ->
			$('.objects').masonry()

	$('body').on 'click', '.archival-toggle', toggleArchival
	$('body').on 'click', '.menu-toggle', toggleMenu
	$('body').on 'mouseenter', '.chapter-square:not(.show)', showChapterCover
	$('body').on 'mouseleave', '.chapter-square', hideChapterCover
	$('body').on 'click', '.tabs .tab:not(.active)', showTab
	$('body').on 'click', '.expand-toggle', toggleExpander
	$('body').on 'click', '.section-anchor', selectSection
	$('body').on 'click', '.chapter-square', selectChapter
	$(window).on 'scroll', onScroll
	$(window).on 'resize', onResize

	getSectionTitles()
	setupSlideshows()