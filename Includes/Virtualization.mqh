//+------------------------------------------------------------------+
//| Virtualization.mqh                                               |
//| Telegram: @grupomql5 & @comunidademql5 // http://t.me/grupomql5  |
//| Por Pedro                                                        |
//+------------------------------------------------------------------+
#property copyright  "Telegram: @grupomql5 || @comunidademql5 || por Pedro em 06.04.2021"
#property description "Virtualização das ordens pendentes e das posições/sl/tp - Em 17.03.2021"
#property version     "1.0"
#include <../Interface.mqh>;
#include <Trade\Trade.mqh>;
CTrade Trade;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CVirtual
  {
public:
   void              CVirtual() { };
   void              Add(ulong order_ticket,string order_type,int order_type0, string order_name,double order_price,double order_open,double order_volume,string order_symbol,double order_sl,double order_tp,string order_comment);
   void              Del(string order_name,bool tipo);
   int               Find(string order_name);
   void              Modify(string order_name,double order_price);
   int               Listar();
   void              VirtualClique(string objname);
   void              OnTick();
   void              xInterface();
  };

CVirtual Virtual;
//+--------------------------------------------------------------------------------+
//| COMANDO PARA CRIAR A INTERFACE GRÁFICA DOS BOTÕES DAS ORDENS/SL/TP VIRTUAIS    |
//+--------------------------------------------------------------------------------+
void CVirtual::xInterface()
  {
     {
      for(int i=0; i<ArraySize(virtual_lista); i++)
        {
         //+------------------------------------------------------------------+
         //| CRIA A INTERFACE GRÁFICA DOS BOTÕES                              |
         //+------------------------------------------------------------------+

         double price_ = hline_mover ? virtual_lista[i].order_info : virtual_lista[i].order_price;
         // Comment(hline_mover," | ",price_," | ",virtual_lista[i].order_info," | ",virtual_lista[i].order_price);
         Interface.Verificar_Valor(i,virtual_lista[i].order_name,price_);
         if(hline_mover)
           {
            //           Interface.Verificar_Valor(i,virtual_lista[i].order_name,price_);
            // ObjectSetDouble(0,hline_select,OBJPROP_PRICE,price_);
           }
         else
           {
            //          Interface.Verificar_Valor(i,virtual_lista[i].order_name,price_);
           }

         if(!hline_mover)
           {
            //+------------------------------------------------------------------+
            //| CRIA A HLINE                                                     |
            //+------------------------------------------------------------------+
            //  ObjectCreate(0,virtual_lista[i].order_name,OBJ_HLINE,0,0,virtual_lista[i].order_price);
            //   HLineCreate(0,virtual_lista[i].order_name,0,virtual_lista[i].order_price,clrFireBrick,STYLE_DASHDOT,1,false,false,true,0);

           }
        }
     }
  }
//+--------------------------------------------------------------------------------------------------------------+
//| COMANDO PARA SER EXECUTADO NO ONTICK - VERIFICA SE O MERCADO ATINGIU O PREÇO DE ALGUMA ORDEM/SL/TP VIRTUAL   |
//+--------------------------------------------------------------------------------------------------------------+
void CVirtual::OnTick(void)
  {
   if(ArraySize(virtual_lista))
     {
      for(int i=0; i<ArraySize(virtual_lista); i++)
        {
         string order_name=   virtual_lista[i].order_name;
         double ask=          SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double bid=          SymbolInfoDouble(_Symbol,SYMBOL_BID);

         //+---------------------------------------------- --------------------+
         //| ORDENS PENDENTE VIRTUAIS                                          |
         //+-------------------------------------------------------------------+

         if(virtual_lista[i].order_type == "OCLVcbxx")
           {
            order_name=   StringSubstr(virtual_lista[i].order_name,0,StringLen(virtual_lista[i].order_name)-5);
            //+------------------------------------------------------------------+
            //| GATILHO PARA ATIVAR ORDENS DO TIPO BUYSTOP                       |
            //+------------------------------------------------------------------+
            if(ArraySize(virtual_lista) && virtual_lista[i].order_type0 == 4 && virtual_lista[i].order_price <= ask)
              {
               //Print("11111");
               Trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,virtual_lista[i].order_volume,virtual_lista[i].order_price,virtual_lista[i].order_sl,virtual_lista[i].order_tp,virtual_lista[i].order_comment);
               Interface.Apagar(virtual_lista[i].order_name,0);
               Del(virtual_lista[i].order_name,0);
               break;
              }
            //+------------------------------------------------------------------+
            //| GATILHO PARA ATIVAR ORDENS DO TIPO BUYSTOP                      |
            //+------------------------------------------------------------------+
            if(ArraySize(virtual_lista) && virtual_lista[i].order_type0 == 2 && virtual_lista[i].order_price >= ask)
              {
               //       Print("2222222");
               Trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,virtual_lista[i].order_volume,virtual_lista[i].order_price,virtual_lista[i].order_sl,virtual_lista[i].order_tp,virtual_lista[i].order_comment);
               Interface.Apagar(virtual_lista[i].order_name,0);
               Del(virtual_lista[i].order_name,0);
               break;
              }
            //+------------------------------------------------------------------+
            //| GATILHO PARA ATIVAR ORDENS DO TIPO SELLLIMIT                     |
            //+------------------------------------------------------------------+
            if(ArraySize(virtual_lista) && virtual_lista[i].order_type0 == 3 && virtual_lista[i].order_price <= bid)
              {
               //          Print("333333");
               Trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,virtual_lista[i].order_volume,virtual_lista[i].order_price,virtual_lista[i].order_sl,virtual_lista[i].order_tp,virtual_lista[i].order_comment);
               Interface.Apagar(virtual_lista[i].order_name,0);
               Del(virtual_lista[i].order_name,0);
               break;
              }
            //+------------------------------------------------------------------+
            //| GATILHO PARA ATIVAR ORDENS DO TIPO SELLSTOP                      |
            //+------------------------------------------------------------------+
            if(ArraySize(virtual_lista) && virtual_lista[i].order_type0 == 5 && virtual_lista[i].order_price >= bid)
              {
               //          Print("44444444");
               Trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,virtual_lista[i].order_volume,virtual_lista[i].order_price,virtual_lista[i].order_sl,virtual_lista[i].order_tp,virtual_lista[i].order_comment);
               Interface.Apagar(virtual_lista[i].order_name,0);
               Del(virtual_lista[i].order_name,0);
               break;
              }
           }
         //+------------------------------------------------------------------+
         //| POSIÇÃO DO TIPO BUY  : STOPLOSS                                  |
         //+------------------------------------------------------------------+
         if(ArraySize(virtual_lista) && !virtual_lista[i].order_type0 && bid <= virtual_lista[i].order_price && virtual_lista[i].order_type == "PSLVcbxx")
           {
            //     Print("6666666: ",virtual_lista[i].order_sl);
            Trade.PositionClose(virtual_lista[i].order_ticket);
            Del(virtual_lista[i].order_name,1);
            break;
           }
         //+------------------------------------------------------------------+
         //| POSIÇÃO DO TIPO BUY  : TAKEPROFIT                                |
         //+------------------------------------------------------------------+
         if(ArraySize(virtual_lista) && !virtual_lista[i].order_type0 && bid >= virtual_lista[i].order_price && virtual_lista[i].order_type == "PTPVcbxx")
           {
            //      Print("77777777: ",virtual_lista[i].order_name," : price:",virtual_lista[i].order_price," tp: ",virtual_lista[i].order_tp," sl: ",virtual_lista[i].order_sl);
            Trade.PositionClose(virtual_lista[i].order_ticket);
            Del(virtual_lista[i].order_name,1);
            break;
           }
         //+------------------------------------------------------------------+
         //| POSIÇÃO DO TIPO SELL  : STOPLOSS                                 |
         //+------------------------------------------------------------------+
         if(ArraySize(virtual_lista) && virtual_lista[i].order_type0 && ask >= virtual_lista[i].order_price && virtual_lista[i].order_type == "PSLVcbxx")
           {
            //      Print("88888");
            Trade.PositionClose(virtual_lista[i].order_ticket);
            Del(virtual_lista[i].order_name,1);
            break;
           }
         //+------------------------------------------------------------------+
         //| POSIÇÃO DO TIPO SELL  : TAKEPROFIT                               |
         //+------------------------------------------------------------------+
         if(ArraySize(virtual_lista) && virtual_lista[i].order_type0 && ask <= virtual_lista[i].order_price && virtual_lista[i].order_type == "PTPVcbxx")
           {
            //       Print("999999");
            Trade.PositionClose(virtual_lista[i].order_ticket);
            Del(virtual_lista[i].order_name,1);
            break;
           }
        }
     }
  }
//+---------------------------------------------------------------------------------------------------------------------+
//|  COMANDO PARA ADICIONAR DETERMINADA POSIÇÃO OU ORDEM PENDENTE NO ARRAY DAS ORDENS/POSIÇÕES VIRTUAIS                 |
//+---------------------------------------------------------------------------------------------------------------------+
void CVirtual::Add(ulong order_ticket,string order_type,int order_type0, string order_name,double order_price,double order_open,double order_volume,string order_symbol,double order_sl,double order_tp,string order_comment)
  {
   int check = Find(order_name);
   if(check < 0)
     {
      double sl;
      double tp;
      ArrayResize(virtual_lista,ArraySize(virtual_lista)+1);
      int position_array=ArraySize(virtual_lista)-1;
      virtual_lista[position_array].order_ticket=order_ticket;
      virtual_lista[position_array].order_type=order_type;
      virtual_lista[position_array].order_type0=order_type0;
      virtual_lista[position_array].order_name=order_name;
      virtual_lista[position_array].order_price=order_price;
      virtual_lista[position_array].order_info=order_price;
      virtual_lista[position_array].order_volume=order_volume;
      virtual_lista[position_array].order_symbol=order_symbol;
      virtual_lista[position_array].order_sl=order_sl;
      virtual_lista[position_array].order_tp=order_tp;
      virtual_lista[position_array].order_comment=order_comment;

      if(StringFind(order_name,"O") >=0)
        {
         sl = OrderGetInteger(ORDER_TYPE) ? -(order_sl-OrderGetDouble(ORDER_PRICE_OPEN)) : order_sl -OrderGetDouble(ORDER_PRICE_OPEN) ;
         tp = OrderGetInteger(ORDER_TYPE) ? -(order_tp-OrderGetDouble(ORDER_PRICE_OPEN)) : order_tp -OrderGetDouble(ORDER_PRICE_OPEN) ;
        }
      else
        {
         sl = PositionGetInteger(POSITION_TYPE) ? -(order_sl-PositionGetDouble(POSITION_PRICE_OPEN)) : order_sl -PositionGetDouble(POSITION_PRICE_OPEN) ;
         tp = PositionGetInteger(POSITION_TYPE) ? -(order_tp-PositionGetDouble(POSITION_PRICE_OPEN)) : order_tp -PositionGetDouble(POSITION_PRICE_OPEN) ;
        }
      virtual_lista[position_array].order_sl_rr=sl;
      virtual_lista[position_array].order_tp_rr=tp;

     }
  }
//+---------------------------------------------------------------------------------------------------------------------+
//|  COMANDO PARA REMOVER DETERMINADA POSIÇÃO OU ORDEM PENDENTE NO ARRAY DAS ORDENS/POSIÇÕES VIRTUAIS                   |
//+---------------------------------------------------------------------------------------------------------------------+
void CVirtual::Del(string order_name,bool tipo)
  {
   if(!tipo)
     {
      int check = Find(order_name);
      if(check >= 0)
        {
         ArrayRemove(virtual_lista,check,1);
         ObjectDelete(0,order_name); //apagar hline
         Interface.Apagar(order_name,0); //apagar botoes
         int index_;
         if(StringFind(order_name,"SLV",0) > 0)
           {
            string objname=StringSubstr(order_name,0,StringLen(order_name)-7)+"TPVcbxx";
            index_=Virtual.Find(objname);
            if(index_ >= 0)
              {
               if(StringFind(objname,"O") >=0)
                 {
                  virtual_lista[index_].order_sl=OrderGetDouble(ORDER_SL);
                 }
               else
                 {
                  virtual_lista[index_].order_sl=PositionGetDouble(POSITION_SL);
           //       Print("index_: ",index_);
           //       Print("deletar margem do stoploss virtual! sl: ", virtual_lista[index_].order_sl," tp: ",virtual_lista[index_].order_tp);
                  //Trade.PositionModify(objname,0,virtual_lista[index_].order_tp);
                 }
              }
           }
         if(StringFind(order_name,"TPV",0) > 0)
           {
            string objname=StringSubstr(order_name,0,StringLen(order_name)-7)+"SLVcbxx";
            index_=Virtual.Find(objname);
            if(index_ >= 0)
              {
               if(StringFind(objname,"O") >=0)
                 {
                  virtual_lista[index_].order_tp=OrderGetDouble(ORDER_TP);
                 }
               else
                 {
                  virtual_lista[index_].order_tp=PositionGetDouble(POSITION_TP);
                 }
              }
           }
        }
     }
   else
     {
      string slname=StringSubstr(order_name,0,StringLen(order_name)-7)+"SLVcbxx";
      int check1 = Find(slname);
      ArrayRemove(virtual_lista,check1,1);
      ObjectDelete(0,slname); //apagar hline
      Interface.Apagar(slname,0); //apagar botoes

      string tpname=StringSubstr(order_name,0,StringLen(order_name)-7)+"TPVcbxx";
      int check2 = Find(tpname);
      ArrayRemove(virtual_lista,check2,1);
      ObjectDelete(0,tpname); //apagar hline
      Interface.Apagar(tpname,0); //apagar botoes
     }
   Interface.Atualizar();
  }
//+---------------------------------------------------------------------------------------------------------------------+
//|  COMANDO PARA MODIFICAR DETERMINADA POSIÇÃO OU ORDEM PENDENTE NO ARRAY DAS ORDENS/POSIÇÕES VIRTUAIS                 |
//+---------------------------------------------------------------------------------------------------------------------+
void CVirtual::Modify(string order_name,double order_price)
  {
   int index=Virtual.Find(order_name);
   if(index >=0)
     {
      virtual_lista[index].order_info=order_price;
      //    Comment(__LINE__,"hline_mover: ",hline_mover," index: ",index," order_name: ",virtual_lista[index].order_name," order_info: ",virtual_lista[index].order_info);
      //   Print(__LINE__,order_price);
      Interface.Verificar_Valor(0,order_name,order_price);
 //     Print(__LINE__,order_name," ",virtual_lista[index].order_type0);

      double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      int index_;

      for(int i=0; i<ArraySize(virtual_lista); i++)
        {
         //  Print("já exite, modificar virtual: ",order_name);
         string objname=StringSubstr(order_name,0,StringLen(order_name)-8);
         //+------------------------------------------------------------------+
         //| MODIFY ORDEM PENDENTE                                            |
         //+------------------------------------------------------------------+

         if(virtual_lista[i].order_name==order_name && StringFind(virtual_lista[i].order_name,"OCLV",0) > 0)
           {
            //+------------------------------------------------------------------+
            //| ORDEM DO TIPO BUY LIMIT                                          |
            //+------------------------------------------------------------------+
            if(virtual_lista[i].order_type0 == 2)
              {
               if(order_price < ask && !hline_mover)
                 {
                  virtual_lista[i].order_price=order_price;
                 }
               if(virtual_lista[index].order_info > ask && !hline_mover)
                 {
                  Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
                 }
              }
            //+------------------------------------------------------------------+
            //| ORDEM DO TIPO SELL LIMIT                                         |
            //+------------------------------------------------------------------+
            if(virtual_lista[i].order_type0 == 3)
              {
               if(order_price < bid && !hline_mover)
                 {
                  virtual_lista[i].order_price=order_price;
                 }
               if(virtual_lista[index].order_info > bid && !hline_mover)
                 {
                  Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
                 }
              }
            //+------------------------------------------------------------------+
            //| ORDEM DO TIPO BUY STOP                                           |
            //+------------------------------------------------------------------+
            if(virtual_lista[i].order_type0 == 4)
              {
               if(order_price < ask && !hline_mover)
                 {
                  virtual_lista[i].order_price=order_price;
                 }
               if(virtual_lista[index].order_info > ask && !hline_mover)
                 {
                  Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
                 }
              }
            //+------------------------------------------------------------------+
            //| ORDEM DO TIPO SELL STOP                                          |
            //+------------------------------------------------------------------+
            if(virtual_lista[i].order_type0 == 5)
              {
               if(order_price < bid && !hline_mover)
                 {
                  virtual_lista[i].order_price=order_price;
                 }
               if(virtual_lista[index].order_info > bid && !hline_mover)
                 {
                  Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
                 }
              }
           }
         //+------------------------------------------------------------------+
         //| MODIFY STOPLOSS :: POSIÇÃO TIPO BUY                              |
         //+------------------------------------------------------------------+

         if(virtual_lista[i].order_name==order_name && StringFind(virtual_lista[i].order_name,"PSLV",0) > 0 && !virtual_lista[i].order_type0)
           {
            if(order_price < bid && !hline_mover)
              {
               //    Print("[1] Está dentro do limite: ",virtual_lista[i].order_name," para:",order_price);
               virtual_lista[i].order_price=order_price;
               virtual_lista[i].order_sl=order_price;
               index_=Virtual.Find(objname+"PTPVcbxx");
               if(index_ >= 0)
                 {
                  // Print("1 TROCOU O INVERSO ",virtual_lista[index_].order_name," para:",order_price);
                  virtual_lista[index_].order_sl=order_price;
                 }
               margem(virtual_lista[i].order_name,order_price);
              }
            if(virtual_lista[index].order_info > bid && !hline_mover)
              {
               // Print("[1] Está fora do limite!");
               Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
              }
           }
         //+------------------------------------------------------------------+
         //| MODIFY TAKEPROFIT :: POSIÇÃO TIPO BUY                            |
         //+------------------------------------------------------------------+
         if(virtual_lista[i].order_name==order_name && StringFind(virtual_lista[i].order_name,"PTPV",0) > 0 && !virtual_lista[i].order_type0)
           {
            //  Print("Takeprofit Buy : ",virtual_lista[i].order_type0,"hline_mover: ",hline_mover);

            if(order_price > bid && !hline_mover)
              {
               //         Print("[2] Está dentro do limite: ",virtual_lista[i].order_name," para:",order_price);
               virtual_lista[i].order_price=order_price;
               virtual_lista[i].order_tp=order_price;
               index_=Virtual.Find(objname+"PSLVcbxx");
               if(index_ >=0)
                 {
                  //           Print("2 TROCOU O INVERSO ",virtual_lista[index_].order_name," para:",order_price);
                  virtual_lista[index_].order_tp=order_price;
                 }
              }
            if(virtual_lista[index].order_info < bid && !hline_mover)
              {
               //        Print("[2] Está fora do limite!");
               Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
              }
           }
         //+------------------------------------------------------------------+
         //| MODIFY STOPLOSS :: POSIÇÃO TIPO SELL                             |
         //+------------------------------------------------------------------+

         if(virtual_lista[i].order_name==order_name && StringFind(virtual_lista[i].order_name,"PSLV",0) > 0 && virtual_lista[i].order_type0)
           {
            //      Print("stoploss sell: ",virtual_lista[i].order_type0,"hline_mover: ",hline_mover);

            if(order_price > ask && !hline_mover)
              {
               //     Print("[3] Está dentro do limite: ",virtual_lista[i].order_name," para:",order_price);
               virtual_lista[i].order_price=order_price;
               virtual_lista[i].order_sl=order_price;
               index_=Virtual.Find(objname+"PTPVcbxx");
               if(index_ >= 0)
                 {
                  //     Print("3 TROCOU O INVERSO ",virtual_lista[index_].order_name," para:",order_price);
                  virtual_lista[index_].order_sl=order_price;
                 }
               margem(virtual_lista[i].order_name,order_price);
              }
            if(virtual_lista[index].order_info < ask && !hline_mover)
              {
               //   Print("[3] Está fora do limite!");
               Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
              }
           }
         //+------------------------------------------------------------------+
         //| MODIFY TAKEPROFIT :: POSIÇÃO TIPO SELL                           |
         //+------------------------------------------------------------------+
         if(StringFind(virtual_lista[i].order_name,"PTPV",0) > 0 && virtual_lista[i].order_type0)
           {
            //      Print("takeprofit sell : ",virtual_lista[i].order_type0,"hline_mover: ",hline_mover);

            if(order_price < ask && !hline_mover)
              {
               //     Print("[4] Está dentro do limite: ",virtual_lista[i].order_name," para:",order_price);
               virtual_lista[i].order_price=order_price;
               virtual_lista[i].order_tp=order_price;
               index_=Virtual.Find(objname+"PSLVcbxx");
               if(index_ >=0)
                 {
                  //     Print("4 TROCOU O INVERSO ",virtual_lista[index_].order_name," para:",order_price);
                  virtual_lista[index_].order_tp=order_price;
                 }
              }
            if(virtual_lista[index].order_info > ask && !hline_mover)
              {
               //    Print("[4] Está fora do limite!");
               Interface.Verificar_Valor(0,virtual_lista[i].order_name,virtual_lista[i].order_price);
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   Info.Update();
  }
//+----------------------------------------------------------------------------------------------------------------------------------------+
//| COMANDO PARA CHECAR PELO NOME DO OBJECTO SE JÁ EXISTE DETERMINADA POSIÇÃO OU ORDEM PENDENTE NO ARRAY DE ORDENS/POSIÇÕES VIRTUAIS       |                                                           |
//+----------------------------------------------------------------------------------------------------------------------------------------+
int CVirtual::Find(string order_name)
  {
// Print("Procurando: ",order_name);
   for(int i=0; i<ArraySize(virtual_lista); i++)
     {
      if(virtual_lista[i].order_name==order_name)
        {
         return(i);
         break;
        }
     }
   return(-1);
  }

//+------------------------------------------------------------------+
//| COMANDO PARA LISTAR AS ORDENS E POSIÇÕES VIRTUAIS DO ARRAY   |
//+------------------------------------------------------------------+
int CVirtual::Listar()
  {
//  Print("Virtual_list-----------------------------------------------");
   int i;
   for(i=0; i<ArraySize(virtual_lista); i++)
     {
      //    Print(i," ",virtual_lista[i].order_name," info: ",DoubleToString(virtual_lista[i].order_info,_Digits)," price: ",virtual_lista[i].order_price," sl: ",virtual_lista[i].order_sl," tp: ",virtual_lista[i].order_tp);
     }
   return(i);
  }

//+----------------------------------------------------------------------------------------+
//| COMANDO EXECUTADO QUANDO SE CLICA NO BOTÃO PARA TRANSFORMAR A ORDEM/SL/TP EM VIRTUAL   |
//+----------------------------------------------------------------------------------------+
void CVirtual::VirtualClique(string objname) //Exemplo string objname = ticket+CLcbxx
  {
   int virtual_ticket=(int)StringSubstr(objname,0,StringFind(objname,"CLcbxx",0));
   string _objname=StringSubstr(objname,0,StringLen(objname)-1);
   int index=Find(_objname);
   int index_;
   PositionSelectByTicket(virtual_ticket);
   double sl;
   double tp;
   if(ArraySize(virtual_lista) > 0 && index >= 0)
     {
      //+--------------------------------------------------------------------+
      //| RETORNA PARA ORDEM NA PEDRA / SE CLICAR EM ORDEM PENDENTE VIRTUAL |
      //+--------------------------------------------------------------------+
      if(StringFind(objname,"OCLVcbxx",0) > 0)
        {
         ENUM_ORDER_TYPE type0= (ENUM_ORDER_TYPE) virtual_lista[index].order_type0;
         Trade.OrderOpen(virtual_lista[index].order_symbol,type0,virtual_lista[index].order_volume,virtual_lista[index].order_price,virtual_lista[index].order_price,virtual_lista[index].order_sl,virtual_lista[index].order_tp);
         Del(_objname,0);
        }
      //+------------------------------------------------------------------+
      //| RETORNA PARA STOPLOSS NA PEDRA / SE CLICAR EM STOPLOSS VIRTUAL   |
      //+------------------------------------------------------------------+
      if(StringFind(objname,"SLVcbxx",0) > 0)
        {
         sl =virtual_lista[index].order_price;
         index_=Virtual.Find(virtual_lista[index].order_name+"PTPVcbxx");
         if(index_ >= 0)
           {
            tp =  virtual_lista[index_].order_price;
           }
         else
           {
            tp = PositionGetDouble(POSITION_TP);
           }
         Trade.PositionModify(virtual_lista[index].order_ticket,sl,tp);
         Interface.Apagar(_objname,0);
         Del(_objname,0);
        }
      //+---------------------------------------------------------------------+
      //| RETORNA PARA TAKEPROFIT NA PEDRA / SE CLICAR EM TAKEPROFIT VIRTUAL  |
      //+---------------------------------------------------------------------+
      if(StringFind(objname,"TPVcbxx",0) > 0)
        {
         index_=Virtual.Find(virtual_lista[index].order_name+"PSLVcbxx");
         if(index_ >= 0)
           {
            sl =  virtual_lista[index_].order_price;
           }
         else
           {
            sl = PositionGetDouble(POSITION_SL);
           }
         tp = virtual_lista[index].order_price;
         Trade.PositionModify(virtual_lista[index].order_ticket,sl,tp);
         Interface.Apagar(_objname,0);
         Del(_objname,0);
        }
     }
   else
     {
      string objn;
      objn=StringFind(objname,"Vcbxx",0) > 0 ? "cbxx" : "Vcbxx";
      objold=StringSubstr(objname,0,StringLen(objname)-5)+"cbxx6";
      objnew6=StringSubstr(objname,0,StringLen(objname)-5)+objn+"6";
      string objnew8=StringSubstr(objname,0,StringLen(objname)-5)+objn+"8";
      // string _objname=StringSubstr(objname,0,StringLen(objname)-1);
      //+------------------------------------------------------------------+
      //| VIRTUALIZAR / SE CLICAR EM ORDEM PENDENTE OU POSIÇÃO NA PEDRA    |
      //+------------------------------------------------------------------+
      if(StringFind(objname,"Vcbxx",0) < 0)
        {
         PositionSelectByTicket(virtual_ticket);
         bool orderselect=OrderSelect(virtual_ticket);
         bool tipo=OrderGetInteger(ORDER_TICKET);
         _text= ObjectGetString(0,_objname+"8",OBJPROP_TEXT);
         _largura= (int) ObjectGetInteger(0,_objname+"7",OBJPROP_XSIZE);
         ulong order_ticket= tipo ?  OrderGetInteger(ORDER_TICKET) : PositionGetInteger(POSITION_TICKET);            // ticket da ordem que do negócio foi executado em
         string order_comment= tipo ? OrderGetString(ORDER_COMMENT) : PositionGetString(POSITION_COMMENT);          // descrição da operação
         double order_volume= tipo ? OrderGetDouble(ORDER_VOLUME_INITIAL) : PositionGetDouble(POSITION_VOLUME);  // volume da operação
         string order_symbol= tipo ? OrderGetString(ORDER_SYMBOL) : PositionGetString(POSITION_SYMBOL);
         double order_price = tipo ? OrderGetDouble(ORDER_PRICE_OPEN) : PositionGetDouble(POSITION_PRICE_OPEN);
         double order_open = order_price;
         double order_sl= tipo ? OrderGetDouble(ORDER_SL) : PositionGetDouble(POSITION_SL);
         double order_tp = tipo ? OrderGetDouble(ORDER_TP) : PositionGetDouble(POSITION_TP);
         //   long order_magic = tipo ? OrderGetInteger(ORDER_MAGIC) : PositionGetInteger(POSITION_TYPE);
         //   long order_type= tipo ? OrderGetInteger(ORDER_TYPE) : PositionGetInteger(POSITION_TYPE);
         //   long order_filling=OrderGetInteger(ORDER_TYPE_FILLING);
         //   long order_time_expiration=OrderGetInteger(ORDER_TIME_EXPIRATION);
         //   long order_type_time= OrderGetInteger(ORDER_TYPE_TIME);
         string order_type;
         //+------------------------------------------------------------------+
         // Se clicar em ordem pendente na pedra de qualquer tipo             |
         //+------------------------------------------------------------------+
         if(StringFind(objname,"OCLcbxx",0) > 0)
           {
            order_type = "OCLVcbxx";
            HLineCreate(0,(string) order_ticket+order_type,0,order_price,clrDarkSlateBlue,STYLE_DASHDOT,1,false,false,true,0);
            Trade.OrderDelete(order_ticket);
            order_type = "OCLVcbxx";
            order_type0_ = (ENUM_ORDER_TYPE) OrderGetInteger(ORDER_TYPE);

           }
         //+------------------------------------------------------------------+
         //| Se clicar na ordem na pedra do tipo stoploss                     |
         //+------------------------------------------------------------------+
         if(StringFind(objname,"PSLcbxx",0) > 0)
           {
            order_type = "PSLVcbxx";
            HLineCreate(0,(string) order_ticket+order_type,0,order_sl,clrFireBrick,STYLE_DASHDOT,1,false,false,true,0);
            Trade.PositionModify(order_ticket,0,order_tp);
            order_price=order_sl;
            order_type0_ = (ENUM_ORDER_TYPE) PositionGetInteger(POSITION_TYPE);
            index_=Virtual.Find((string)order_ticket+"PTPVcbxx");
            if(index_ >= 0)
              {
               order_tp=virtual_lista[index_].order_price;
              }
           }
         //+-------------------------------------------------------------------+
         //| VIRTUALIZAÇÃO :: Se clicar na POSIÇÃO na pedra do tipo takeprofit |
         //+-------------------------------------------------------------------+
         if(StringFind(objname,"PTPcbxx",0) > 0)
           {
            order_type = "PTPVcbxx";
            HLineCreate(0,(string) order_ticket+order_type,0,order_tp,pos_cor_linha_virtual,STYLE_DASHDOT,1,false,false,true,0);
            Trade.PositionModify(order_ticket,order_sl,0);
            order_price=order_tp;
            order_type0_ = (ENUM_ORDER_TYPE) PositionGetInteger(POSITION_TYPE);
            //  ObjectCreate(0,(string) order_ticket+order_type,OBJ_HLINE,0,0,order_tp);

            index_=Virtual.Find((string)order_ticket+"PSLVcbxx");
            if(index_ >= 0)
              {
               order_sl=virtual_lista[index_].order_price;
              }
           }
         string order_name=(string)order_ticket+order_type;
         Add(order_ticket,order_type,order_type0_,order_name,order_price,order_open,order_volume,order_symbol,order_sl,order_tp,order_comment);

         if(StringFind(order_name,"PSLV",0) > 0)
           {
            margem(order_name,order_price);
           }
         ObjectSetString(0,objnew6,OBJPROP_TEXT,"V");
        }
     }
   xInterface();
  }

//+------------------------------------------------------------------+
//| FUNÇÃO PARA ADICIONAR MARGEM DE SEGURANÇA DO STOPLOSS VIRTUAL    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void margem(string name, double price)
  {
   if(margem_estado)
     {
      int index=Virtual.Find(name);
      if(index >= 0)
        {
         ulong ticket=virtual_lista[index].order_ticket;
         double tp=virtual_lista[index].order_tp;
         //double tp=virtual_lista[index].order_tp;
         int type0_=virtual_lista[index].order_type0;
         if(!type0_)
           {
            Trade.PositionModify(ticket,price-(margem_de_seguranca),tp);
            //      Trade.PositionModify(ticket,price-result,tp);
           }
         if(type0_)
           {
            Trade.PositionModify(ticket,price+(margem_de_seguranca),tp);
            //   Trade.PositionModify(ticket,price+result,tp);
           }
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
