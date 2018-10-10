<?php
function archtober_scripts() {
	$ver = '1.0.1';
	wp_enqueue_style( 'bootstrap', 'https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css', null );
	wp_enqueue_style( 'fonts', 'https://fonts.googleapis.com/css?family=Open+Sans%3A400italic%2C600italic%2C700italic%2C400%2C300%2C600%2C700&subset=latin%2Carabic&ver=4.9.8', null );
	wp_enqueue_style( 'style', get_stylesheet_uri(), null, $ver );
	wp_enqueue_script( 'jquery', 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js', array(), true );
	wp_enqueue_script( 'masonry', 'https://unpkg.com/masonry-layout@4/dist/masonry.pkgd.min.js', array(), true );
	wp_enqueue_script( 'imagesLoaded', 'https://cdnjs.cloudflare.com/ajax/libs/jquery.imagesloaded/4.1.4/imagesloaded.pkgd.min.js', array(), true );
	wp_enqueue_script( 'scripts', get_template_directory_uri() . '/assets/js/script.js', array(), $ver, true );
}
add_action( 'wp_enqueue_scripts', 'archtober_scripts' );


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
	register_nav_menu( 'nav', __( 'Navigation', 'nakba' ) );
}
add_action( 'after_setup_theme', 'register_navigation' );


function get_body_excerpt( $body ) {
	if( $more_pos = strpos( $body, '<!--more-->' ) ) {
		echo '<div class="expand-wrapper">';
			echo '<div class="body-excerpt">'.substr( $body, 0, $more_pos ).'</div>';
			echo '<div class="body-after-excerpt expand-content"><div class="expand-inner">'.substr( $body, $more_pos ).'</div></div>';
			echo '<h3 class="expand-toggle">';
				echo '<span class="more">Read More</span>';
				echo '<span class="less">Read Less</span>';
			echo '</h3>';
		echo '</div>';
	} else {
		echo $body;
	}
}


add_theme_support( 'post-thumbnails', array( 'chapters' ) );
add_image_size( 'custom', 900, 900, true );

add_filter( 'show_admin_bar', '__return_false' );
?>