module BinaryPlistHelper
	require 'cfpropertylist'

	#Class Methods
	class << self 
		def hash_from_plist_file(plist_file_path)
			if !plist_file_path
				return nil
			end

			plist = CFPropertyList::List.new(:file => plist_file_path)
	  		data = CFPropertyList.native_types(plist.value)
	  		return data
		end

		# get icon's zip path from parsed_plist_hash and zip_app_path
		# params: parsed_plist_hash : returned data from `hash_from_plist_file`
		# first find parsed_plist_hash["CFBundleIconFiles"].last
		# then find parsed_plist_hash["CFBundleIcons"]["CFBundlePrimaryIcon"]["CFBundleIconFiles"].last
		# then find parsed_plist_hash["CFBundleIconFile"]
		def get_icon_file_name(parsed_plist_hash)
			return nil if (!parsed_plist_hash || !parsed_plist_hash.respond_to?(:has_value?))

			icon_array = parsed_plist_hash["CFBundleIconFiles"] # first find parsed_plist_hash["CFBundleIconFiles"].last
			if !icon_array || icon_array.length == 0 # then find parsed_plist_hash["CFBundleIcons"]["CFBundlePrimaryIcon"]["CFBundleIconFiles"].lastObject
				bundle_icons = parsed_plist_hash["CFBundleIcons"]
				if bundle_icons
					primary_icon = bundle_icons["CFBundlePrimaryIcon"]
					if primary_icon
						icon_array = primary_icon["CFBundleIconFiles"]
					end
				end
			end

			if icon_array && icon_array.length != 0
				return icon_array.last
			else
				return parsed_plist_hash["CFBundleIconFile"]
			end

			return parsed_plist_hash["CFBundleIconFile"]
		end

		# get iTuneArtwork
		def get_itunes_artwork_file_name(parsed_plist_hash)
			return 'iTuneArtwork'
		end

		# get version string from hash
		def get_version_string(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleVersion"]
		end

		# get short version string from hash
		def get_short_version_string(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleShortVersionString"]
		end

		# get bundle id from hash
		def get_bundle_id(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleIdentifier"]
		end

		# get display name from hash
		def get_display_name(parsed_plist_hash)
			return nil if !parsed_plist_hash
			return parsed_plist_hash["CFBundleDisplayName"]
		end
	end
end
