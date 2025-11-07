

import "package:flutter/material.dart";



class CounterBox extends StatefulWidget{
  int count;
  bool toOperator=false;
  
  final ValueChanged<int>? onChanged;
  //final ValueChanged<int>? onIndex;

  CounterBox({this.count=0,this.toOperator=false,this.onChanged,});
  
  State<CounterBox> createState()=>_counterbox();
}

class _counterbox extends State<CounterBox>{
  
  Widget build(BuildContext context){
    
    return Center(
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(50),
          color: Colors.amber
        ),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 20,
          direction: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () {
                // Warning
                setState(() {
                  (!widget.toOperator)?  widget.count==1? widget.count=1:widget.count-- :
                         widget.count==0? widget.count=0:widget.count--;
                });
                widget.onChanged?.call(widget.count);
              },
              child: Icon(
                Icons.remove
              ),
            ),
            
            Text( "${widget.count}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black54),),
            GestureDetector(
              onTap:(){
                setState(() {
                 widget.count==10? widget.count=10:widget.count++;
                });
                widget.onChanged?.call(widget.count);
              },
              child: Icon(
                Icons.add,
                
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}