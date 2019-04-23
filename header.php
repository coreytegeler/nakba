<!DOCTYPE html>
<html <?php language_attributes(); ?> class="no-js no-svg">
<head>
<?= htmlspecialchars_decode( get_field( 'ga_data_layer', 'option' ) ); ?>
<title><?php bloginfo( 'title' ); ?> | Amnesty International</title>
<meta charset="<?php bloginfo( 'charset' ); ?>">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="profile" href="http://gmpg.org/xfn/11">
<?php wp_head(); ?>
</head>

<body <?php body_class( pll_current_language() ); ?>>
<?= htmlspecialchars_decode( get_field( 'ga_noscript', 'option' ) ); ?>
<?php
echo '<header class="desktop">';
	echo '<div class="row align-items-center h-100">';
		echo '<div class="col header-titles">';
			echo '<a href="'.get_home_url().'" class="site-title"><h4>'.get_bloginfo( 'title' ).'</h4></a>';
				if( $post && $post->post_type == 'chapters' ) {
					$curr_chapter = $post;
				} else {
					$chapter_query = new WP_Query( array(
						'post_type' => 'chapters',
						'posts_per_page' => 1,
						'post_status' => array('publish', 'draft' ),
						'order' => 'ASC',
						'orderby' => 'date',
					) );
					$curr_chapter = $chapter_query->posts[0];
				}
				echo '<a href="'.get_the_permalink( $curr_chapter ).'" class="chapter-title"><h4>'.get_the_title( $curr_chapter ).'</h4></a>';
		echo '</div>';
		echo '<div class="col col-auto">';
			$desktop_menu_slug = 'desktop';
			if ( ( $locations = get_nav_menu_locations() ) && isset( $locations[ $desktop_menu_slug ] ) ) {
			  $desktop_menu = wp_get_nav_menu_object( $locations[ $desktop_menu_slug ] );
			  $desktop_menu_items = wp_get_nav_menu_items( $desktop_menu );
			  if( $desktop_menu_items ) {
					echo '<nav>';
						foreach ( $desktop_menu_items as $key => $desktop_menu_item ) {
							echo '<div class="menu-item">';
								echo '<a href="'.$desktop_menu_item->url.'" target="'.$desktop_menu_item->target.'">';
									echo '<h4 class="'.implode( ' ', $desktop_menu_item->classes ).'">'.$desktop_menu_item->title.'</h4>';
								echo '</a>';
							echo '</div>';
						}
					echo '</nav>';
				}
			}
		echo '</div>';
	echo '</div>';
echo '</header>';
echo '<header class="mobile">';
	$mobile_menu_slug = 'mobile';
	if ( ( $locations = get_nav_menu_locations() ) && isset( $locations[ $mobile_menu_slug ] ) ) {
		$mobile_menu = wp_get_nav_menu_object( $locations[ $mobile_menu_slug ] );
		$mobile_menu_items = wp_get_nav_menu_items( $desktop_menu );
		if( $mobile_menu_items ) {
			echo '<nav>';
				foreach ( $mobile_menu_items as $key => $mobile_menu_item ) {
					echo '<div class="menu-item">';
						echo '<a href="'.$mobile_menu_item->url.'" target="'.$mobile_menu_item->target.'">';
							echo '<h4 class="'.implode( ' ', $mobile_menu_item->classes ).'">'.$mobile_menu_item->title.'</h4>';
						echo '</a>';
					echo '</div>';
				}
			echo '</nav>';
		}
	}
echo '</header>';
echo '<div class="menu-toggle mobile">';
	echo '<div class="icon-open" style="background-image:url('.get_template_directory_uri().'/assets/imgs/open.svg)"></div>';
	echo '<div class="icon-close" style="background-image:url('.get_template_directory_uri().'/assets/imgs/close.svg)"></div>';
echo '</div>';
// if( is_home() || is_front_page() || is_404() ) {
	// echo '<main>';
// } else {
	// echo '<main class="loaded" data-id="'.$curr_chapter->ID.'">';
	// include '_chapter.php';
// }
?>