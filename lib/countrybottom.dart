import 'package:flutter/material.dart';



class CountryBottomSheet extends StatefulWidget {
  @override
  _CountryBottomSheetState createState() => _CountryBottomSheetState();
}

class _CountryBottomSheetState extends State<CountryBottomSheet> {

  List<String> countries = [
    "Andorra","Angola","Algeria","Argentina",
    "Armenia","Australia","Austria","Azerbaijan",
    "Bahamas","Bahrain","Bangladesh","Barbados","Belarus"
  ];
  Map<String, String> countryCodes = {
    "Andorra": "ad",
    "Angola": "ao",
    "Algeria": "dz",
    "Argentina": "ar",
    "Armenia": "am",
    "Australia": "au",
    "Austria": "at",
    "Azerbaijan": "az",
    "Bahamas": "bs",
    "Bahrain": "bh",
    "Bangladesh": "bd",
    "Barbados": "bb",
    "Belarus": "by",
  };

  String selectedCountry = "";

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, controller) {

        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.all(16),

          child: Column(
            children: [

              /// 🔘 Drag handle
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              SizedBox(height: 20),

              /// 🔍 SEARCH
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search country name",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// ⭐ FAVOURITES
              _sectionTitle("Add Your Favourite Country"),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _favChip("Afghanistan"),
                  _favChip("India"),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _favChip("Australia"),
                  _favChip("Bahrain"),
                ],
              ),

              SizedBox(height: 20),

              /// 📍 SELECT COUNTRY
              _sectionTitle("Select"),

              SizedBox(height: 10),

              /// 📜 LIST
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {

                    String country = countries[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCountry = country;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [

                            /// radio
                            Icon(
                              selectedCountry == country
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: selectedCountry == country
                                  ? Colors.orange
                                  : Colors.grey,
                            ),

                            SizedBox(width: 10),

                            /// name
                            Expanded(
                              child: Text(
                                country,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            /// flag (placeholder)
                            ///
                            ///

                            CircleAvatar(

                              radius: 12,
                              backgroundImage: NetworkImage(
                                "https://flagcdn.com/w40/${countryCodes[country]}.png",),
                            ),



                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  /// 🔹 Favourite Chip
  Widget _favChip(String text) {

    String c_code="in";
    if(text.compareTo("India")==0)
      {
        c_code="in";
      }
    else if(text.compareTo("Afghanistan")==0){
      c_code="af";
    }
    else if(text.compareTo("Australia")==0){
      c_code="au";
    }
    else{

      c_code="bh";
    }


      return Container(

        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// orange dot
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),

            SizedBox(width: 8),

            /// country name
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),

            SizedBox(width: 8),

            /// flag
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://flagcdn.com/w40/$c_code.png",
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      );


  }
}