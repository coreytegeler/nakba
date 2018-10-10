jQuery(document).ready ($) ->
	body = $('body')
	blocks = $('.blocks')
	sectionTitles = $('.section-titles')
	archivalMaterials = $('#archival-materials')

	#ADD BLOCK TITLES TO FOOTER
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

	clickSectionTitle = (e) ->
		e.preventDefault()
		scrollToSection(e.target.hash)

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
		#RESET MASONRY
		$('.objects').masonry()
		#RESIZE SIDESHOWS
		$('.block-media.slideshow').each (i, block) ->
			block = $(block)
			if ratio = block.attr('data-ratio')
				newHeight = block.innerWidth()*ratio
				block.css
					height: newHeight+30+'px'


	#TOGGLE ARCHIVAL MATERIAL OVERLAY
	toggleArchival = (e) ->
		body.toggleClass('open-archive')
		if archivalMaterials.is('.open-archive')
			body.addClass('no-scroll')
		else
			body.removeClass('no-scroll')

	#SHOW CHAPTER COVER IMAGE WHEN HOVERING ON THE TITLE CARD
	showChapterCover = (e) ->
		slug = $(this).data('slug')
		media = $('.media[data-slug="'+slug+'"]')
		if media.length
			$('.media').removeClass('show')
			media.addClass('show')

	#HIDE CHAPTER COVER IMAGE WHEN HOVERING OFF THE TITLE CARD
	hideChapterCover = (e) ->
		$('.media').removeClass('show')

	#OPEN TAB CONTENT ON CLICK OF TAB
	showTab = (e) ->
		id = $(this).data('id')
		$content = $('.tab-content[data-id="'+id+'"]')
		$('.tab, .tab-content').removeClass('active')
		$(this).addClass('active')
		$content.addClass('active')



	#EXPAND OR COLLAPSE CONTENT SECTION
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
		titles = []
		$('.section-title').each (i, sectionTitle) ->
			if scrollTop >= $(sectionTitle).offset().top
				sectionTitleText = $(sectionTitle).find('.section-title-text').text()
				titles.push(sectionTitleText)
		currTitle = titles[titles.length-1]
		currTitleHtml = sectionTitles.find('[data-title="'+currTitle+'"]')
		$('.section-title').not(currTitleHtml).removeClass('active')
		currTitleHtml.addClass('active')


	slugify = (str) ->
		return str.toString().toLowerCase()
			.replace(/\s+/g, '-')
			.replace(/[^\w\-]+/g, '')
			.replace(/\-\-+/g, '-')
			.replace(/^-+/, '')
			.replace(/-+$/, '')

	#INITIALIZATION FUNCTIONS
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
	

	#EVENT LISTENERS
	$('body').on 'click', '.archival-toggle', toggleArchival
	$('body').on 'mouseenter', '.chapter-square:not(.show)', showChapterCover
	$('body').on 'mouseleave', '.chapter-square', hideChapterCover
	$('body').on 'click', '.tabs .tab:not(.active)', showTab
	$('body').on 'click', '.expand-toggle', toggleExpander
	$('body').on 'click', '.section-anchor', clickSectionTitle
	$(window).on 'scroll', onScroll
	$(window).on 'resize', onResize


	#ON LOAD
	getSectionTitles()
	setupSlideshows()