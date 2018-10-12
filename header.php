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
			echo '<a href="'.get_home_url().'" class="site-title"><h3>'.get_bloginfo( 'title' ).'</h3></a>';
			echo '<a href="'.get_the_permalink().'" class="chapter-title"><h3>';
				if( $chapter_title = get_the_title() ) {
					$chapter_title;
				}
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


$chapters_query = new WP_Query( array(
	'post_type' => 'chapters',
	'posts_per_page' => -1,
	'post_status' => array('publish', 'draft' ),
	'order' => 'ASC',
	'orderby' => 'date',
) );

echo '<div id="cover">';
	
	echo '<div id="cover-media">';
		echo '<div class="media video">';
			echo '<video autoplay loop muted>';
				echo '<source src="https://nakba.amnesty.org/wp-content/uploads/2018/05/croppedSmoke_3.mp4" type="video/mp4">';
			echo '</video>';
		echo '</div>';	
		if( $chapters_query->have_posts() ) {
			while( $chapters_query->have_posts() ) {
				$chapters_query->the_post();
				if( has_post_thumbnail() ) {
					echo '<div class="media image" style="background-image:url('.get_the_post_thumbnail_url().');" data-slug="'.$post->post_name.'"></div>';
				}
			}
		}
	echo '</div>';

	echo '<div id="cover-overlay" class="align-items-center">';
		echo '<div class="row">';
			echo '<div class="col col-sm-12 col-md-6 col-lg-4">';
				echo '<div class="align-items-center h-100">';
					echo '<div class="cover-title">';
						echo '<h1 class="cover-title-row ar">سبعون</h1>';
						echo '<h1 class="cover-title-row en">Seventy</h1>';
						echo '<h1 class="cover-title-row ar">عاما من</h1>';
						echo '<h1 class="cover-title-row en">Years of</h1>';
						echo '<h1 class="cover-title-row ar">الاختناق</h1>';
						echo '<h1 class="cover-title-row en">Suffocation</h1>';
						echo '<div class="cover-sub-title">';
							echo '<h4>'.get_bloginfo( 'description' ).'</h4>';
						echo '</div>';
						echo '<a href="https://amnesty.org" class="amnesty-logo">';
							echo '<img src="'.get_template_directory_uri().'/assets/imgs/amnesty.png">';
						echo '</a>';
					echo '</div>';
				echo '</div>';
			echo '</div>';
			echo '<div class="col col-sm-12 col-md-6 col-lg-8">';
				echo '<div class="align-items-center h-100">';
					echo '<div class="chapter-squares">';
						if( $chapters_query->have_posts() ) {
							while( $chapters_query->have_posts() ) {
								$chapters_query->the_post();
								echo '<a class="chapter-square '.$post->post_status.'" href="'.get_the_permalink().'" data-title="'.$post->post_title.'" data-id="'.$post->ID.'">';
									echo '<h3>'.$post->post_title.'</h3>';
								echo '</a>';
							}
							wp_reset_postdata();
						}
					echo '</div>';
				echo '</div>';
			echo '</div>';
		echo '</div>';
	echo '</div>';
echo '</div>';
echo '<main></main>';
?>
