import "package:flutter/material.dart";


class CustomeBox extends StatelessWidget{
  String orderCount="";
  String orderName="";
  String orderImg="";
  VoidCallback OnPressed;

  CustomeBox({
    this.orderCount="",
    required this.OnPressed,
    this.orderImg="",
    this.orderName=""
  });
  
 Widget build(BuildContext context){
  return Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                    child: Card(
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
                                                image: AssetImage(orderImg),
                                                fit: BoxFit.cover,
                                            ),
                                        ),    
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Flex(
                                                direction: Axis.vertical,
                                                mainAxisSize:MainAxisSize.min,
                                                spacing: 2,
                                                children: [
                                                    Text(
                                                        orderName,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black45
                                                        ),
                                                    ),
                                                    RichText(
                                                      text:TextSpan(
                                                        text: "Sifariş Sayi ",
                                                        style: TextStyle(
                                                          fontSize:18, 
                                                          color:Colors.black.withValues(alpha: 0.7),
                                                          fontWeight: FontWeight.w500  ,
                                                           
                                                        ),
                                                        children: [
                                            
                                                          TextSpan(
                                                            text: orderCount,
                                                            style: TextStyle(
                                                              fontSize:20, 
                                                              color:Colors.green.withValues(alpha: 0.8),
                                                              fontWeight: FontWeight.w700,  
                                                            
                                                            ),
                                                          )
                                                        ]
                                                      ),
                                                      
                                                    ),
                                                    Text(
                                                        "Bu Sifiraşi",
                                                        style: TextStyle(
                                                            fontSize: 20,
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
                                                            onTap: OnPressed,
                                                            borderRadius: BorderRadius.circular(5),
                                                            child: Card(
                                                              elevation: 1,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5)
                                                                ),
                                                                color: Colors.red.shade400,
                                                                child: SizedBox(
                                                                  width: 100,
                                                                  height: 35,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(3),
                                                                    child: Text(
                                                                      textAlign: TextAlign.center,
                                                                      "ləğv et",
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black.withValues(alpha: 0.7),
                                                                            fontFamily: "NatoSans"
                                                                        ),
                                                                    ),
                                                                  ),
                                                                )
                                                            )
                                                            
                                                            /*Container(
                                                                width: 100,
                                                                height: 35,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    color: Colors.red.withValues(alpha: 0.7)
                                                                ),
                                                                child: Text(
                                                                    "ləğv et",
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black.withValues(alpha: 0.7),
                                                                        fontFamily: "NatoSans"
                                                                    ),
                                                                ),
                                                            )
                                                            */
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