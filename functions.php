<?php
function seventy_scripts() {
	$ver = '1.3.5';
	$env = ( in_array( $_SERVER['REMOTE_ADDR'], array( '127.0.0.1', '::1' ) ) ? 'dev' : 'prod' );
	$min = ($env=='prod'?'.min':'');
	wp_enqueue_style( 'bootstrap', 'https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.min.css', null );
	wp_enqueue_style( 'style', get_template_directory_uri() . '/assets/css/style'.$min.'.css', null, $ver );
	wp_enqueue_script( 'jquery', 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js', array(), true );
	wp_enqueue_script( 'jquery-mobile', get_template_directory_uri() . '/assets/js/jquery.mobile.custom.min.js', array(), true );
	wp_enqueue_script( 'masonry', 'https://cdnjs.cloudflare.com/ajax/libs/masonry/4.2.2/masonry.pkgd.min.js', array(), true );
	wp_enqueue_script( 'imagesLoaded', 'https://cdnjs.cloudflare.com/ajax/libs/jquery.imagesloaded/4.1.4/imagesloaded.pkgd.min.js', array(), true );
	wp_enqueue_script( 'custom-script', get_template_directory_uri() . '/assets/js/script'.$min.'.js', array( 'imagesLoaded', 'masonry', 'jquery', 'jquery-mobile' ) );
	wp_localize_script( 'ajax-script', 'ajax_obj', array(
		'ajaxurl' => admin_url( 'admin-ajax.php' ),
	));
}
add_action( 'wp_enqueue_scripts', 'seventy_scripts' );

function get_chapter() {
	global $post;
	$post = get_post( $_POST['id'] );
	setup_postdata( $post );
	get_template_part( 'single-chapters' );
	die();
}
add_action( 'wp_ajax_nopriv_get_chapter', 'get_chapter' );
add_action( 'wp_ajax_get_chapter', 'get_chapter' );

function register_chapters() {
	register_post_type( 'chapters',
		array(
			'labels' => array(
				'name' => __( 'Chapters' ),
				'singular_name' => __( 'Chapter' )
			),
			'menu_position' => 3,
			'menu_icon' => 'dashicons-format-aside',
			'public' => true,
			'has_archive' => true,
			'supports' => array('title', 'thumbnail', 'editor', 'revisions', 'comments'),
			'show_in_rest' => true,
		)
	);
}
add_action( 'init', 'register_chapters' );

if( function_exists('acf_add_options_page') ) {
	acf_add_options_page();
}

function remove_menus() {
	remove_menu_page( 'edit.php' );
	remove_menu_page( 'jetpack' );
	remove_menu_page( 'edit-comments.php' );
}
add_action( 'admin_menu', 'remove_menus' );

function register_navigation() {
	register_nav_menu( 'desktop', __( 'Desktop', 'nakba' ) );
	register_nav_menu( 'mobile', __( 'Mobile', 'nakba' ) );
}
add_action( 'after_setup_theme', 'register_navigation' );


function get_body_excerpt( $body ) {
	$more_str = '<p>READMORE</p>';
	$more_len = strlen( $more_str );
	$more_pos = strpos( $body, $more_str );
	if( !$more_pos ) {
		$more_str = '<p dir="rtl">READMORE</p>';
		$more_len = strlen( $more_str );
		$more_pos = strpos( $body, $more_str );
	}
	if( !$more_pos ) {
		$more_str = '<p class="p2" dir="rtl">READMORE</p>';
		$more_len = strlen( $more_str );
		$more_pos = strpos( $body, $more_str );
	}
	if( $more_pos ) {
		echo '<div class="expand-wrapper">';
			echo '<div class="body-excerpt">'.substr( $body, 0, $more_pos-$more_len ).'</div>';
			echo '<div class="body-after-excerpt expand-content"><div class="expand-inner">'.substr( $body, $more_pos+$more_len ).'</div></div>';
			echo '<h3 class="expand-toggle">';
				echo '<span class="more">'.pll__( 'Read More' ).'</span>';
				echo '<span class="less">'.pll__( 'Read Less' ).'</span>';
			echo '</h3>';
		echo '</div>';
	} else {
		echo '<div class="body-excerpt">'.$body.'</div>';
	}
}

if( function_exists( 'pll_register_string' ) ) {
	pll_register_string( 'Archival Materials', 'Archival Materials' );
	pll_register_string( 'Read More', 'Read More' );
	pll_register_string( 'Read Less', 'Read Less' );
	pll_register_string( 'Coming Soon', 'Coming Soon' );
}

function allow_mimes( $mimes = array() ) {
	$mimes['svg'] = 'text/svg';
	return $mimes;
}
add_action('upload_mimes', 'allow_mimes');


add_theme_support( 'post-thumbnails', array( 'chapters' ) );
add_image_size( 'custom', 900, 900, true );

add_filter( 'show_admin_bar', '__return_false' );
add_filter( 'xmlrpc_enabled', '__return_false' );
?>
