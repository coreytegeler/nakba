<?php global $post; ?>
<!DOCTYPE html>
<html <?php language_attributes(); ?> class="no-js no-svg">
<head>
<title><?php bloginfo( 'title' ); ?></title>
<meta charset="<?php bloginfo( 'charset' ); ?>">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="profile" href="http://gmpg.org/xfn/11">
<?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
<?php
echo '<header class="desktop">';
	echo '<div class="row align-items-center h-100">';
		echo '<div class="col">';
			echo '<a href="'.get_home_url().'"><h3>';
				echo get_bloginfo( 'title' ) . ( $post ? '&nbsp;'.$post->title : '' );
			echo '</h3></a>';
		echo '</div>';
		echo '<div class="col-auto">';
			$desktop_menu_slug = 'desktop';
			if ( ( $locations = get_nav_menu_locations() ) && isset( $locations[ $desktop_menu_slug ] ) ) {
			  $desktop_menu = wp_get_nav_menu_object( $locations[ $desktop_menu_slug ] );
			  $desktop_menu_items = wp_get_nav_menu_items( $desktop_menu );
			  if( $desktop_menu_items ) {
					echo '<nav>';
						foreach ( $desktop_menu_items as $key => $desktop_menu_item ) {
							echo '<div class="menu-item">';
								echo '<a href="'.$desktop_menu_item->url.'">';
									echo '<h3>'.$desktop_menu_item->title.'</h3>';
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
						echo '<a href="'.$mobile_menu_item->url.'">';
							echo '<h3>'.$mobile_menu_item->title.'</h3>';
						echo '</a>';
					echo '</div>';
				}
			echo '</nav>';
		}
	}
echo '</header>';
echo '<div class="menu-toggle mobile">';
	echo '<div class="dot"></div>';
	echo '<div class="dot"></div>';
	echo '<div class="dot"></div>';
echo '</div>';
?>
