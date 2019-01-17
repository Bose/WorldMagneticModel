Pod::Spec.new do |s|
  s.name         = "WorldMagneticModel"
  s.version      = "1.0.2"
  s.summary      = "An iOS native wrapper around the World Magnetic Model"

  s.description  = <<-DESC
The World Magnetic Model is a joint product of the United States’ National Geospatial-Intelligence Agency (NGA) and the United Kingdom’s Defence Geographic Centre (DGC). The WMM was developed jointly by the National Geophysical Data Center (NGDC, Boulder CO, USA) (now the National Centers for Environmental Information (NCEI)) and the British Geological Survey (BGS, Edinburgh, Scotland).

The World Magnetic Model is the standard model used by the U.S. Department of Defense, the U.K. Ministry of Defence, the North Atlantic Treaty Organization (NATO) and the International Hydrographic Organization (IHO), for navigation, attitude and heading referencing systems using the geomagnetic field. It is also used widely in civilian navigation and heading systems. The model, associated software, and documentation are distributed by NCEI on behalf of NGA. The model is produced at 5-year intervals, with the current model expiring on December 31, 2019.

Further information about the World Magnetic Model is available at https://www.ngdc.noaa.gov/geomag/WMM/
                   DESC

  s.homepage     = "https://bose.com"
  s.license      = { :type => 'MIT' }
  s.author       = "Bose Corporation"
  s.source       = { :git => "https://github.com/Bose/WorldMagneticModel.git", :tag => "#{s.version}" }

  s.platform = :ios, "11.0"
  s.source_files  = "Source/**/*.{h,m,c}"
  s.public_header_files = "Source/*.h"
  s.private_header_files = "Source/*+Internal.h", "Source/WMM/*.h"

  s.resource  = "Source/WMM/WMM.COF"

end
