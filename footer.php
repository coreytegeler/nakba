<?php if( $post && ( $post->post_type == 'chapters' || $post->post_type == 'post' ) ) { ?>
	<footer>
		<div class="row align-items-center h-100">
			<div class="col section-titles desktop">
			</div>
			<div class="col-auto">
				<a href="#archive" class="archive-toggle">
					<div class="corner"></div>
					<?= pll__( 'Archival Materials' ); ?>
				</a>
			</div>
		</div>
	</footer>
<?php } ?>
<?php wp_footer(); ?>
</body>
</html>
