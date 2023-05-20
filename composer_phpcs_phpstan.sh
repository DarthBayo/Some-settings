#! /bin/bash

composer=$(composer -v > /dev/null 2>&1)

if [[ $composer -ne 0 ]]; then
	# Installing composer
	exec php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	| php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	| php composer-setup.php \
	| php -r "unlink('composer-setup.php');" \
	| sudo mv composer.phar /usr/local/bin/composer

	# Installing drupal coder
	exec composer global require --dev drupal/coder

	# Installing phpcs
	exec curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
	| sudo mv phpcs.phar /usr/local/bin/phpcs \
	| curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
	| sudo mv phpcbf /usr/local/bin/phpcbf

	# Installing phpstan
	exec composer global require --dev phpstan/phpstan \
	| sudo cp ~/.config/composer/vendor/phpstan/phpstan/phpstan.phar /usr/local/bin/phpstan

	# Settings coder
	exec phpcs --config-set installed_paths ~/.config/composer/vendor/drupal/coder/coder_sniffer
fi

echo "Finished"
