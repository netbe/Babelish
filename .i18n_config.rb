# put me where you are going to execute the script
# ex: iOSProject/resources/i18n_config.rb

CSV2StringsConfig = {
	:keys_column  => 1,
	:default_lang => 'Anglais',
	:langs        => {
		'Anglais'  => [:en],
		'Francais' => [:fr],
		'Espagnol' => [:es],
		'Italien'  => [:it],
		'Allemand' => [:de],
		'Chinois'  => [:"zh-Hans", :"zh-Hant"]
	},
	:state_column    => 10,
	:excluded_states => ['NOT USEFUL']
}

Strings2CSVConfig = {
	:output_file => 'Translations.csv',
	:keys_column => 'Variables',
	:default_lang=> :en,
	:langs       => {
		:en        => 'Anglais',
		:es        => 'Espagnol',
		:fr        => 'Francais',
		:it        => 'Italien',
		:de        => 'Allemand',
		:"zh-Hans" => 'Chinois'
	}
}