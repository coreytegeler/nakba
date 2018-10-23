<?php if( $post && $post->post_type == 'chapters' ) { ?>
	<footer>
	<div class="row align-items-center h-100">
		<div class="col section-titles desktop">
		</div>
		<div class="col-auto">
			<a href="#archival" class="archival-toggle">
				<div class="corner"></div>
				<h5><?= pll__( 'Archival Materials' ); ?></h5>
			</a>
		</div>
	</div>
	</footer>
<?php } ?>
<?php wp_footer(); ?>
</body>
</html>
