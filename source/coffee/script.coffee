jQuery(document).ready ($) ->
	body = $('body')
	blocks = $('.blocks')
	blockTitles = $('.block-titles')
	archivalMaterials = $('#archival-materials')

	#ADD BLOCK TITLES TO FOOTER
	getBlockTitles = () ->
		blocks.children().each (i, block) ->
			title = $(block).find('.block-title').text()
			if title
				blockTitles.append('<h3 class="block-title">'+title+'</h3>')


	#TOGGLE ARCHIVAL MATERIAL OVERLAY
	toggleArchival = (e) ->
		archivalMaterials.toggleClass('open')
		if archivalMaterials.is('.open')
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

	#
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
	$('body').on 'click', '.expand-toggle', toggleExpander


	#ON LOAD
	getBlockTitles()