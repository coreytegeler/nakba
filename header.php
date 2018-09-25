<?php global $post; ?>
<!DOCTYPE html>
<html <?php language_attributes(); ?> class="no-js no-svg">
<head>
<meta charset="<?php bloginfo( 'charset' ); ?>">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="profile" href="http://gmpg.org/xfn/11">
<?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
<?php
echo '<header id="header" class="desktop">';
	echo '<div class="row align-items-center h-100">';
		echo '<div class="col">';
			echo '<a href="'.get_home_url().'"><h3>';
				echo get_bloginfo( 'title' ) . ( $post ? '&nbsp;'.$post->title : '' );
			echo '</h3></a>';
		echo '</div>';
		echo '<div class="col-auto">';
			$nav_menu_slug = 'nav';
			if ( ( $locations = get_nav_menu_locations() ) && isset( $locations[ $nav_menu_slug ] ) ) {
			  $nav_menu = wp_get_nav_menu_object( $locations[ $nav_menu_slug ] );
			  $nav_menu_items = wp_get_nav_menu_items( $nav_menu );
			  if( $nav_menu_items ) {
					echo '<nav id="nav">';
						foreach ( $nav_menu_items as $key => $nav_menu_item ) {
							echo '<div class="menu-item">';
								echo '<a href="'.$nav_menu_item->url.'">';
									echo '<h3>'.$nav_menu_item->title.'</h3>';
								echo '</a>';
							echo '</div>';
						}
					echo '</nav>';
				}
			}
		echo '</div>';
	echo '</div>';
echo '</header>';
echo '<div id="header-toggle" class="mobile">';
	echo '<div class="dot"></div>';
	echo '<div class="dot"></div>';
	echo '<div class="dot"></div>';
echo '</div>';
?>