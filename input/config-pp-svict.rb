#Config file for Peter Plaoul Svict mss.
$confighash = {
	#General Manifest Info
	msslug: "pp-svict",
	msabbrev: "SV",
	manifestLabel: "Peter Plaoul - St. Victor",
	manifestDescription: "Witness to Peter Plaoul's Commentary on the Sentences", 
	seeAlso: "",
	author: "Peter Plaoul",
	logo: "http://upload.wikimedia.org/wikipedia/fr/thumb/8/84/Logo_BnF.svg/1280px-Logo_BnF.svg.png",
	attribution: "BnF",

	#Presentation Context
	presentation_context: "http://iiif.io/api/presentation/2/context.json",
	
	# Sequence Info
	viewingDirection: "left-to-right",

	#Canvas Info
	canvasWidth: 1721, 
	canvasHeight: 2445,
	type: "single", # indicates if images are single sides or facing pages.
	i: 187, # starting folio
	numberOfFolios: 373, #end number of folios
	side: "r", #starting folio side
	folio_skip_array: [],
	folio_bis_array: [],

	#Image Info
	imageFormat: "image/jpeg", 
	imageWidth: 1721,
	imageHeight: 2445,

	#Image Service Info
	serviceType: "SCTA",
	image_context: "http://iiif.io/api/image/2/context.json",
	image_service_profile: "http://iiif.io/api/image/1/level2.json",
	image_service_base: "http://images.scta.info:3000/",
	image_service_count: 1, # service count number (i.e. starting number for Gallica)
	image_service_skip_array: [],

	#Annotation List Info
	annotationListIdBase: "http://scta.info/iiif/pp-svict/list/"


	
}