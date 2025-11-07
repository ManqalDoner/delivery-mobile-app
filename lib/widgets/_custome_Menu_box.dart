import "package:flutter/material.dart";

class MenuBox extends StatelessWidget{
    
    String imgUrl="";
    String name="";
    String price="";
    VoidCallback onPressed;
    MenuBox({
        this.name="",
        this.imgUrl="",
        this.price="",
        required this.onPressed,
    });

    Widget build(BuildContext context){
        return Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                    child:Card(
                            
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(25)
                            ),
                            child: Container(
                                height: 150,
                                child: Row(
                                    children: [
                                        ClipRRect(
                                            borderRadius: BorderRadiusGeometry.horizontal(left: Radius.circular(25)),
                                            child: Image(
                                                width: 150,
                                                height: 150,
                                                image: AssetImage(imgUrl),
                                                fit: BoxFit.cover,
                                            ),
                                        ),    
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Flex(
                                                direction: Axis.vertical,
                                                mainAxisSize:MainAxisSize.min,
                                                spacing: 10,
                                                children: [
                                                    Text(
                                                        name,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black45
                                                        ),
                                                    ),
                                                    Text(
                                                        "$price₼",
                                                        
                                                        style: TextStyle(
                                                            fontSize: 23,
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: "NotoSans"
                                                        ),
                                                    ),
                                                    // add oerder button
                                                    Material(
                                                        borderRadius: BorderRadius.circular(5),
                                                        elevation: 0,
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                            onTap: onPressed,
                                                            borderRadius: BorderRadius.circular(5),
                                                            child: Card(
                                                              elevation: 1,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5)
                                                                ),
                                                                color: Colors.amber,
                                                                child: SizedBox(
                                                                  width: 100,
                                                                  height: 35,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(5),
                                                                    child: Text(
                                                                      textAlign: TextAlign.center,
                                                                      "Sifariş",
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black.withValues(alpha: 0.7)
                                                                        ),
                                                                    ),
                                                                  ),
                                                                )
                                                            )
                                                        ),
                                                    )
                                                ],
                                            )
                                        )                                    
                                    ],
                                
                                ),
                            )
                             
                        
                    ),
                )
            
        );
    }
}