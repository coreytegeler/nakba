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
				titleHtml = $('<h3 class="section-title"></h3>')
					.html(title).attr('data-title', title)
				sectionTitles.append(titleHtml)


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

	$(window).on 'resize', () ->
		$('.objects').masonry()
	

	#EVENT LISTENERS
	$('body').on 'click', '.archival-toggle', toggleArchival
	$('body').on 'mouseenter', '.chapter-square:not(.show)', showChapterCover
	$('body').on 'mouseleave', '.chapter-square', hideChapterCover
	$('body').on 'click', '.tabs .tab:not(.active)', showTab
	$('body').on 'click', '.expand-toggle', toggleExpander
	$(window).on 'scroll', onScroll


	#ON LOAD
	getSectionTitles()