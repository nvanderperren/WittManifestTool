module WittManifests
	class Creator

		def initialize (confighash, output)
			@msslug = confighash[:msslug]
			@msabbrev = confighash[:msabbrev]
			@manifestLabel = confighash[:manifestLabel]
			@manifestDescription = confighash[:manifestDescription]
			@seeAlso = confighash[:seeAlso]
			@author = confighash[:author]
			@viewingDirection = confighash[:viewingDirection]
			@numberOfFolios = confighash[:numberOfFolios]
			@canvasWidth = confighash[:canvasWidth]
			@canvasHeight = confighash[:canvasHeight] 
			@imageFormat = confighash[:imageFormat]
			@imageWidth = confighash[:imageWidth]
			@imageHeight = confighash[:imageHeight]
			@type = confighash[:type]
			@i = confighash[:i]
			
			@side = confighash[:side]
			@folio_skip_array = confighash[:folio_skip_array]
			@folio_bis_array = confighash[:folio_bis_array]
			
			@outputdir = output
			@annotationListIdBase = confighash[:annotationListIdBase]
			
			@presentation_context = confighash[:presentation_context]
			
			@serviceType = confighash[:serviceType]
			@image_context = confighash[:image_context]
			@image_service_profile = confighash[:image_service_profile]
			@image_service_base = confighash[:image_service_base]
			@image_service_count = confighash[:image_service_count]
			@image_service_skip_array = confighash[:image_service_skip_array] 

			#require "../configfiles"
		end

		def manifest

		manifestHash = {
	    "@context"=>@presentation_context,
	    "@id" => "http://scta.info/iiif/#{@msslug}/manifest",
	    "@type"=>"sc:Manifest",

	    "label"=>@manifestLabel,
	    "metadata"=>
	    [
	      {
	          "label"=>"Author",
	          "value"=> @author
	      },
	      {
	          "label"=>"Published",
	          "value"=> [
	              {
	                  "@language"=> "la"
	              }
	          ]
	      }
	    ],
	    "description"=> @manifestDescription,
	    "license": "https://creativecommons.org/publicdomain/zero/1.0/",
	    "attribution"=> "BnF",
	    "seeAlso": @seeAlso,
	    "logo": "https://raw.githubusercontent.com/IIIF/m2/master/images/logos/bnf-logo.jpeg",
	    "sequences": self.sequence
	  }
		#manifest = IIIF::Presentation::Manifest.new(manifestHash)
		#manifest.sequences << self.sequence
		puts manifestHash.to_json(pretty: true)
		end
		def sequence
			sequenceHash = [{
	        "@context"=>@presentation_context,
	        "@id"=> "http://scta.info/iiif/#{@msslug}/sequence/normal",
	        "@type"=> "sc:Sequence",
	        "label"=> "Current page order",
	        "viewingDirection" => @viewingDirection,
	        "viewingHint" => "paged",
	        "canvases": self.canvases
	      }]
	    return sequenceHash
		end
		def canvases
			canvasArray = []
			@already_used_folios = []

			until @i > @numberOfFolios
			  
				## begin a series of checks to see if certain folios or image servide ids need to be skipped

				## first check: has a folio or folios been skipped in the actual numeration of the manuscript. 
				## if true, then skip these folio numbers in the canvaas creation
				while @folio_skip_array.include? @i
					@i += 1
				end
			 	
			 	## second check: does the image service numeration create duplicates that need to be skipped
			 	## if so skip these image ids

			  while @image_service_skip_array.include? @image_service_count
			  	@image_service_count +=1
			  end

			  ## Third Check: check to see if a folio number has been repeated in the actual manuscript foliation and create the foliation 
			  ## this currently varies on whether or not the available images are single pages (which is the ideal)
			  ## or if the images are facing pages.
			  ## if an folio numeration is repeated create the folio label "folio number" + "bis" 
			  ## if the folio is a single page add the side designation (e.g. "r" or "v")

			  if @type == "single"
			    if defined? @folio_bis_array 
			      #checks to see if the verso side of the first instance has already been logged.
			      if @already_used_folios.include? @i
			        fol = @i.to_s + "bis" + @side
			      else
			        fol = @i.to_s + @side
			      end
			    else
			      fol = @i.to_s + @side
			    end
			  elsif @type == "double"
			    if defined? @folio_bis_array # currently on works for verso recto double page image
			      if @already_used_folios.include? @i
			        fol = @i.to_s + "bis"
			      else
			        fol = @i 
			      end
			    else
			      fol = @i  
			    end
			  end 

			  ## Fourth Check: Identify the image service and create service ids specifically designed for each service. 
			  ## New servicesids should be added for each new image-service ui pattern
			  
			  if @serviceType == "Gallica"
			  	serviceid = @image_service_base + "f#{@image_service_count}"
			  elsif @serviceType == "SCTA"
			  	serviceid = @image_service_base + "#{@msslug}/#{@msabbrev}#{fol}.jpg"
			  #add other cases here
			  end

			  
			  canvas =  {
			      "@context"=>@presentation_context,
			      "@id"=>"http://scta.info/iiif/#{@msslug}/canvas/#{@msabbrev}#{fol}",
			      "@type"=>"sc:Canvas",
			      "label"=> "folio #{fol}",
			      "height"=>@canvasHeight,
			      "width"=>@canvasWidth,
			      "images"=>[
			          {
			          "@context"=>@presentation_context,
			          #{}"@type" => "http://www.shared-canvas.org/ns/context",
			          "@id"=> "http://scta.info/iiif/#{@msslug}/annotation/#{@msabbrev}#{fol}-image",
			          "@type"=> "oa:Annotation",
			          "motivation" => "sc:painting",
			          "resource" => {
			            "@id" => "http://scta.info/iiif/#{@msslug}/res/#{@msabbrev}#{fol}.jpg",
			            "@type"=> "dctypes:Image",
			            "format"=> @imageFormat,
			            "service"=> {
			                "@context"=> @image_context,
			                "@id"=> serviceid,
			                "profile"=> @image_service_profile
			                },
			            "height"=>@imageHeight,
			            "width"=>@imageWidth,
			          },
			        "on"=> "http://scta.info/iiif/#{@msslug}/canvas/#{@msabbrev}#{fol}"
			        }
			      ]
			  }
			  
			  unless @annotationListIdBase == nil
			  	canvas["otherContent"] = [
			  		{
			  			"@id" => "http://scta.info/iiif/#{@msslug}/list/#{@msabbrev}#{fol}",
			  			"@type" => "sc:AnnotationList"
			  		}
			  	]
			  end

			  canvasArray << canvas

			  ## Begin preparation for next iteration.
			  ## if canvases are being created for each side of a leaf, side designation needs to flipped from "r to v" 
			  ## or from "v" to "r" with uptick in the folio counter 
			  ## also needs to account for folio numerations that are repeated and need to be marked as "bis"


			  if @type == "single"
			    if defined? @folio_bis_array 
			      if @folio_bis_array.include? @i
			        @i = @i
			          if @side == "v"
			            @folio_bis_array.delete(@i)
			            @already_used_folios << @i
			          end
			        if fol == "#{@i}r" || fol == "#{@i}bisr"
			          @side = "v"
			        else
			          @side = "r"
			        end
			      else
			        if fol == "#{@i}r" || fol == "#{@i}bisr"
			          @i = @i
			          @side = "v"
			        else
			          @i+=1
			          @side = "r"
			        end
			      end
			    else
			      if fol == "#{@i}r" || fol == "#{@i}bisr"
			        @i = @i
			        @side = "v"
			      else
			        @i+=1
			        @side = "r"
			      end
			    end
			  else
			    if defined? @folio_bis_array 
			      if @folio_bis_array.include? @i
							@i = @i
			        @folio_bis_array.delete(@i)
			        @already_used_folios << @i
			      else
			        @i+=1
			      end    
			    else
			      @i+=1
			    end
			  end

			  @image_service_count += 1

			end
			return canvasArray
		end
	end 
end