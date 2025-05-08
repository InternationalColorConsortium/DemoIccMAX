class Iccmax < Formula
  desc "Reference implementation tools for iccMAX"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.1.26.tar.gz"
  sha256 "e3bff2e0e7876faebe4a2097eefa2a190325bcc04c152ef470449f0c01b41fa7"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "nlohmann-json"
  depends_on "wxwidgets"
  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
      -DENABLE_TOOLS=ON
      -DENABLE_SHARED_LIBS=ON
      -DENABLE_INSTALL_RIM=ON
      -DENABLE_ICCXML=ON
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"srgb_profile.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <IccProfile>
        <Header>
          <PreferredCMMType></PreferredCMMType>
          <ProfileVersion>5.00</ProfileVersion>
          <ProfileDeviceClass>scnr</ProfileDeviceClass>
          <DataColourSpace>RGB </DataColourSpace>
          <PCS>XYZ </PCS>
          <CreationDateTime>2021-01-01T12:00:00</CreationDateTime>
          <ProfileFlags EmbeddedInFile="true" UseWithEmbeddedDataOnly="false"/>
          <DeviceAttributes ReflectiveOrTransparency="reflective" GlossyOrMatte="glossy" MediaPolarity="negative" MediaColour="colour"/>
          <RenderingIntent>Absolute</RenderingIntent>
          <PCSIlluminant>
            <XYZNumber X="0.964202880859" Y="1.000000000000" Z="0.824905395508"/>
          </PCSIlluminant>
          <ProfileCreator></ProfileCreator>
          <ProfileID>24B7E09909DC98AAD3D5B287A68C1700</ProfileID>
          <SpectralPCS>rs0021</SpectralPCS>
          <SpectralRange>
           <Wavelengths start="400.00000000" end="720.00000000" steps="33"/>
          </SpectralRange>
        </Header>
        <Tags>
          <profileDescriptionTag> <multiLocalizedUnicodeType>
            <LocalizedText LanguageCountry="enUS"><![CDATA[Canon 1DMarkIII Camera Model under D50 Light Source]]></LocalizedText>
          </multiLocalizedUnicodeType> </profileDescriptionTag>

          <AToB3Tag> <multiProcessElementType>
            <MultiProcessElements InputChannels="3" OutputChannels="3">
              <MatrixElement InputChannels="3" OutputChannels="3">
                <MatrixData>
                  0.665845870972 0.781081974506 -0.155892789364
                  4.923550128937 -3.952824831009 2.796829938889
                  1.274327158928 1.977722287178 -4.353931427002
                </MatrixData>
              </MatrixElement>
              <MatrixElement InputChannels="3" OutputChannels="3">
                <MatrixData>
                  0.964245557785 0.205258548260 0.047809105366
                  1.000000000000 0.014650168829 0.017621353269
                  0.824679076672 0.035736683756 -0.400589108467
                </MatrixData>
              </MatrixElement>
            </MultiProcessElements>
          </multiProcessElementType> </AToB3Tag>

          <BToD3Tag> <multiProcessElementType>
            <MultiProcessElements InputChannels="33" OutputChannels="3">
              <CalculatorElement InputChannels="33" OutputChannels="3">
                <SubElements>
                  <MatrixElement InputChannels="33" OutputChannels="3">
                    <MatrixData>
                      0.000063066233 0.000166109050 0.000353413372 0.000194502936 0.000122614350 0.000109743472 0.000133774884 0.000171185966 0.000250662852 0.000359724334 0.001080623595 0.002134574344 0.005659507122 0.012468191795 0.014062709175 0.011393273249 0.015516501851 0.030570777133 0.033723007888 0.060345917940 0.058205824345 0.053489387035 0.046035319567 0.039401780814 0.029836844653 0.023171914741 0.016233114526 0.007436857559 0.001356909052 0.000254624785 0.000054439821 0.000014979583 0.000004784633
                      0.000244990544 0.000980189536 0.004406625871 0.005194141995 0.007496827748 0.010650031269 0.012965057977 0.018381869420 0.033647231758 0.049918234348 0.102549202740 0.090859323740 0.097081512213 0.108249627054 0.100449159741 0.094961985946 0.081019431353 0.069163933396 0.036496363580 0.034775193781 0.018142636865 0.008936764672 0.004710157868 0.003158182837 0.002095604548 0.001457256498 0.001087151002 0.000671310059 0.000181307303 0.000048136444 0.000014409108 0.000004297510 0.000001851069
                      0.001187714864 0.009011781774 0.044583693147 0.061740174890 0.077923491597 0.082451574504 0.091048762202 0.089393623173 0.084818996489 0.068145304918 0.073974549770 0.033204492182 0.015624751337 0.007865742780 0.004488787148 0.002473828848 0.001126986928 0.000693035778 0.000346420449 0.000355643337 0.000243540009 0.000159278497 0.000131566601 0.000123545295 0.000147814862 0.000186687306 0.000207536184 0.000126078347 0.000025814288 0.000005412481 0.000001796944 0.000001031619 0.000000919039
                    </MatrixData>
                  </MatrixElement>
                </SubElements>
                <MainFunction>
                  { 49.257473 56.461254 59.9841 57.77327 74.77597 87.198036 90.56694
                    91.328621 95.072884 91.934525 95.700813 96.594368 97.115372 102.08889
                    100.74836 102.31386 100 97.73745 98.923592 93.510246 97.705742 99.291847
                    99.067947 95.750679 98.89344 95.705421 98.234177 103.05432 99.184952
                    87.424179 91.652931 92.933578 76.891418 in[0,33] mul[33] mtx(0)
                    2974.8767 2974.8767 2974.8767 div[3] out[0,3] }
                </MainFunction>
              </CalculatorElement>
            </MultiProcessElements>
          </multiProcessElementType> </BToD3Tag>

          <spectralViewingConditionsTag> <spectralViewingConditionsType>
            <StdObserver>Unknown observer</StdObserver>
            <IlluminantXYZ X="0.963888049126" Y="1.000000000000" Z="0.824088394642"/>
            <ObserverFuncs start="380.00000000" end="730.00000000" steps="36">>
             0.001368000056 0.004242999945 0.014310000464 0.043510001153 0.134379997849 0.283899992704 0.348280012608 0.336199998856
             0.290800005198 0.195360004902 0.095640003681 0.032010000199 0.004900000058 0.009300000034 0.063270002604 0.165500000119
             0.290399998426 0.433450013399 0.594500005245 0.762099981308 0.916299998760 1.026299953461 1.062199950218 1.002599954605
             0.854449987411 0.642400026321 0.447899997234 0.283499985933 0.164900004864 0.087399996817 0.046769998968 0.022700000554
             0.011358999647 0.005789999850 0.002898999956 0.001440000022
             0.000038999999 0.000119999997 0.000395999989 0.001210000017 0.004000000190 0.011599999852 0.023000000045 0.037999998778
             0.059999998659 0.090980000794 0.139019995928 0.208020001650 0.323000013828 0.503000020981 0.709999978542 0.861999988556
             0.953999996185 0.994949996471 0.995000004768 0.952000021935 0.870000004768 0.757000029087 0.630999982357 0.503000020981
             0.381000012159 0.264999985695 0.174999997020 0.107000000775 0.061000000685 0.032000001520 0.017000000924 0.008209999651
             0.004102000035 0.002091000089 0.001047000056 0.000520000001
             0.006450000219 0.020050000399 0.067850001156 0.207399994135 0.645600020885 1.385599970818 1.747059941292 1.772109985352
             1.669199943542 1.287639975548 0.812950015068 0.465180009604 0.272000014782 0.158199995756 0.078249998391 0.042160000652
             0.020300000906 0.008750000037 0.003899999894 0.002099999925 0.001649999991 0.001099999994 0.000799999980 0.000339999999
             0.000190000006 0.000049999999 0.000019999999 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000
             0.000000000000 0.000000000000 0.000000000000 0.000000000000
            </ObserverFuncs>
            <StdIlluminant>Illuminant D50</StdIlluminant>
            <ColorTemperature>5000.000000000000</ColorTemperature>
            <IlluminantSPD start="380.00000000" end="730.00000000" steps="36">>
             0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000
             0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000
             0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000
             0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000
             0.000000000000 0.000000000000 0.000000000000 0.000000000000
            </IlluminantSPD>
            <SurroundXYZ X="0.963888049126" Y="1.000000000000" Z="0.824088394642"/>
          </spectralViewingConditionsType> </spectralViewingConditionsTag>

          <mediaWhitePointTag> <XYZArrayType>
            <XYZNumber X="0.964202880859" Y="1.000000000000" Z="0.824905395508"/>
          </XYZArrayType> </mediaWhitePointTag>

          <copyrightTag> <multiLocalizedUnicodeType>
            <LocalizedText LanguageCountry="enUS"><![CDATA[Copyright 2014 International Color Consortium]]></LocalizedText>
          </multiLocalizedUnicodeType> </copyrightTag>

        </Tags>
      </IccProfile>
    EOS

    system "#{bin}/iccFromXml", "srgb_profile.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system "#{bin}/iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
