//+------------------------------------------------------------------+
//| InfoUpdate.mqh                                                   |
//| Telegram: @grupomql5 & @comunidademql5 // http://t.me/grupomql5  |
//| Por Pedro                                                        |
//+------------------------------------------------------------------+
#property copyright  "Telegram: @grupomql5 || @comunidademql5 || por Pedro em 06.04.2021"
#property description "Informações de texto que devem ser atualizada nas barras a cada tick - Em 26.11.2021"
#property version     "1.1"
#include <../Virtualization.mqh>;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class InfoUpdate
  {

protected:
   string            Moeda(double pontos, double volume);
   string            Porc(double open, double current);
   string            TipoOrder(string tipoordem);
   int               NumeroDaPosicao(int ticket);
   int               NumeroDaOrdem(int ticket);

public:
                     InfoUpdate() {};
                    ~InfoUpdate() {};

   void              Update() { Update_Ordens(); Update_Posicoes(); ChartRedraw(); }
   //  void              Update() { ChartRedraw(); }
   void              Update_Ordens();
   void              Update_Posicoes();
   string            ReplaceVirtualPOS(int num, int index, int ticket, string infos, string tipo);
   string            ReplaceVirtualORD(int num, int index, int ticket, string infos, string tipo);
   string            ReplacePedraPOS(int ticket, string infos, string tipo);
   string            ReplacePedraORD(int ticket, string infos, string tipo);
   int               Normalizar(string objname);
  };
double lucro;
InfoUpdate Info;
//+------------------------------------------------------------------+
//| ATUALIZAR INFORMAÇÕES NA BARRA DAS POSIÇÕES/SL/TP                |
//+------------------------------------------------------------------+
void InfoUpdate::Update_Posicoes()
  {
   int total=PositionsTotal();
   if(total > 0)
     {
      string objname7;
      string objname8;
      string texto_;
      for(int i=0; i<total; i++)
        {
         string ticket=(string) PositionGetTicket(i);
         string ticket_symbol=PositionGetSymbol(i);
         if(ticket_symbol==ChartSymbol(0))
           {
            //+------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DA POSIÇÃO NA PEDRA               |
            //+------------------------------------------------------------------+
            objname7= (string) ticket+"PCLcbxx7";
            objname8= (string) ticket+"PCLcbxx8";
            texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_texto_mini : pos_texto_grande;
            Interface.AlterarTexto(0, objname8, ReplacePedraPOS((int) ticket, texto_, "pos_open"), objname7);
            //       ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_open);
            //+------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DE STOPLOSS NA PEDRA              |
            //+------------------------------------------------------------------+
            if(PositionGetDouble(POSITION_SL))
              {
               objname7= (string) ticket+"PSLcbxx7";
               objname8= (string) ticket+"PSLcbxx8";
               texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_sl_texto_mini : pos_sl_texto_grande;
               Interface.AlterarTexto(0, objname8, ReplacePedraPOS((int) ticket, texto_, "pos_SL"), objname7);
               //          ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_SL);
              }
            //+------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DE TAKEPROFIT NA PEDRA            |
            //+------------------------------------------------------------------+
            if(PositionGetDouble(POSITION_TP))
              {
               objname7= (string) ticket+"PTPcbxx7";
               objname8= (string) ticket+"PTPcbxx8";
               texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_tp_texto_mini : pos_tp_texto_grande;
               Interface.AlterarTexto(0, objname8, ReplacePedraPOS((int) ticket, texto_, "pos_TP"), objname7);
               //          ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_TP);
              }
            //+------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DE STOPLOSS VIRTUAL                |
            //+------------------------------------------------------------------+
            int virtual_index_sl=Virtual.Find(ticket+"PSLVcbxx");
            if(virtual_index_sl > -1)
              {
               objname7= (string) ticket+"PSLVcbxx7";
               objname8= (string) ticket+"PSLVcbxx8";
               texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_sl_texto_mini : pos_sl_texto_grande;
               Interface.AlterarTexto(0, objname8, ReplaceVirtualPOS(i, virtual_index_sl, (int) ticket, texto_, "pos_SL"), objname7);
               //           ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_SL);
              }
            //+------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DE POSIÇÃO TAKEPROFIT             |
            //+------------------------------------------------------------------+
            int virtual_index_tp=Virtual.Find(ticket+"PTPVcbxx");
            if(virtual_index_tp > -1)
              {
               objname7= (string) ticket+"PTPVcbxx7";
               objname8= (string) ticket+"PTPVcbxx8";
               texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_tp_texto_mini : pos_tp_texto_grande;
               Interface.AlterarTexto(0, objname8, ReplaceVirtualPOS(i, virtual_index_tp, (int) ticket, texto_, "pos_TP"), objname7);
               //           ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_TP);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| ATUALIZAR INFORMAÇÕES NA BARRA DAS ORDENS PENDENTES              |
//+------------------------------------------------------------------+
void InfoUpdate::Update_Ordens()
  {
   string objname7;
   string objname8;
   string texto_;
   int total=OrdersTotal();
   if(total > 0)
     {
      for(int i=0; i<total; i++)
        {
         string ticket=(string) OrderGetTicket(i);
         string ticket_symbol=OrderGetString(ORDER_SYMBOL);
         if(ticket_symbol==ChartSymbol(0))
           {
            //+------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DE ORDEM NA PEDRA                 |
            //+------------------------------------------------------------------+
            objname7= (string) ticket+"OCLcbxx7";
            objname8= (string) ticket+"OCLcbxx8";
            texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? ord_texto_mini : ord_texto_grande;
            Interface.AlterarTexto(0, objname8, ReplacePedraORD((int) ticket, texto_, "ord_open"), objname7);
            //   ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_texto);
            break;
            //+------------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DE ORDEM STOPLOSS NA PEDRA              |
            //+------------------------------------------------------------------------+
            if(OrderGetDouble(ORDER_SL))
              {
               objname7= (string) ticket+"OSLcbxx7";
               objname8= (string) ticket+"OSLcbxx8";
               texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_sl_texto_mini : pos_sl_texto_grande;
               Interface.AlterarTexto(0, objname8, ReplacePedraORD((int) ticket, texto_, "ord_SL"), objname7);
               //        ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_texto);
               break;
              }
            //+------------------------------------------------------------------+
            //| ATUALIZAR INFORMAÇÕES NA BARRA DE TAKEPROFIT NA PEDRA            |
            //+------------------------------------------------------------------+
            if(OrderGetDouble(ORDER_TP))
              {
               objname7= (string) ticket+"OTPcbxx7";
               objname8= (string) ticket+"OTPcbxx8";
               texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_tp_texto_mini : pos_tp_texto_grande;
               Interface.AlterarTexto(0, objname8, ReplacePedraORD((int) ticket, texto_, "ord_TP"), objname7);
               ///           ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_texto);
               break;
              }
           }
        }
     }
   int total2=Virtual.Listar();
//  Comment(total2);
   if(total2 >= 0)
     {
      for(int i=0; i<total2; i++)
        {
         //     Print(i," ",virtual_lista[i].order_name);
         if(StringFind(virtual_lista[i].order_name, "O") >= 0)
           {
            string ticket=(string) virtual_lista[i].order_ticket;
            string ticket_symbol=virtual_lista[i].order_symbol;
            //   Print(" 2 ordem virtual n: ",i);
            if(ticket_symbol==ChartSymbol(0))
              {
               //+------------------------------------------------------------------+
               //| ATUALIZAR INFORMAÇÕES NA BARRA DE ORDEM VIRTUAL                  |
               //+------------------------------------------------------------------+
               // int virtual_index_ord=Virtual.Find(ticket+"OCLVcbxx");
               if(StringFind(virtual_lista[i].order_name, "OCLV") >= 0)
                 {
                  //Print("OCLV: ",virtual_lista[i].order_name);
                  //Print("ticket: ",ticket);
                  objname7= (string) ticket+"OCLVcbxx7";
                  objname8= (string) ticket+"OCLVcbxx8";
                  texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? ord_texto_mini : ord_texto_grande;
                  Interface.AlterarTexto(0, objname8, ReplaceVirtualORD(i, i, (int) ticket, texto_, "ord_open"), objname7);
                  break;
                 }
               //+------------------------------------------------------------------+
               //| ATUALIZAR INFORMAÇÕES NA BARRA DE ORDEM STOPLOSS VIRTUAL         |
               //+------------------------------------------------------------------+
               // int virtual_index_sl=Virtual.Find(ticket+"OSLVcbxx");
               if(StringFind(virtual_lista[i].order_name, "OSLV") >= 0)
                 {
                  objname7= (string)
                            ticket+"OSLVcbxx7";
                  objname8= (string) ticket+"OSLVcbxx8";
                  texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_sl_texto_mini : pos_sl_texto_grande;
                  Interface.AlterarTexto(0, objname8, ReplaceVirtualORD(i, i, (int) ticket, texto_, "ord_SL"), objname7);
                  //           ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_texto);
                  break;
                 }
               //+------------------------------------------------------------------+
               //| ATUALIZAR INFORMAÇÕES NA BARRA DE ORDEM TAKEPROFIT               |
               //+------------------------------------------------------------------+
               //int virtual_index_tp=Virtual.Find(ticket+"OTPVcbxx");
               if(StringFind(virtual_lista[i].order_name, "OTPV") >= 0)
                 {
                  objname7= (string) ticket+"OTPVcbxx7";
                  objname8= (string) ticket+"OTPVcbxx8";
                  texto_=ObjectGetInteger(0, objname7, OBJPROP_XSIZE) == largura_2_barra ? pos_tp_texto_mini : pos_tp_texto_grande;
                  Interface.AlterarTexto(0, objname8, ReplaceVirtualORD(i, i, (int) ticket, texto_, "ord_TP"), objname7);
                  //          ObjectSetInteger(0,objname8,OBJPROP_COLOR,cor_texto);
                  break;
                 }
              }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//| FUNÇÃO PARA CONVERTER PONTOS/PIPS EM VALOR MONETÁRIO             |
//+------------------------------------------------------------------+
string InfoUpdate::Moeda(double pontos, double volume)
  {
   double divisor=1.0;
   if(_Symbol == "Bra50")
     {
     }
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double lotValue = volume * (tickValue / tickSize);
   double resultado = (pontos*lotValue/divisor);
   return DoubleToString(resultado, 2) + " $";
  }
//+----------------------------------------------------------------------------------------------------------------------+
//| FUNÇÃO PARA CALCULAR A PORCENTAGEM DA DISTANCIA ENTRE A POSIÇÃO/ORDEM ABERTA E O NÍVEL DE STOPLOSS OU TAKEPROFIT     |
//+----------------------------------------------------------------------------------------------------------------------+
string InfoUpdate::Porc(double open, double current)
  {
   if(open > 0)
     {
      return DoubleToString(MathAbs(current-open)*100/open, 2);
     }
   return("?");
  }
//+-------------------------------------------------------------------------------------------------------+
//| FUNÇÃO PARA SUBSTIUIR OS CORINGAS DOS TEXTO CUSTOMIZADO COM AS INFORMAÇÕES DA POSIÇAO/SL/TP VIRTUAL   |
//+-------------------------------------------------------------------------------------------------------+
string InfoUpdate::ReplaceVirtualPOS(int num, int index, int ticket, string infos, string tipo)
  {
//  PositionSelectByTicket(ticket);
//Print("ticket: ",ticket," objname: ",virtual_lista[index].order_name," tp: ",virtual_lista[index].order_tp," sl: ",virtual_lista[index].order_sl);
   int index_;
   double double_tp;
   double double_sl;
   index_=Virtual.Find((string)ticket+"PTPVcbxx");
   if(index_ >= 0)
     {
      //   Print("TP: Existe takeprift virtual");      // virtual_lista[index].order_tp=virtual_lista[index_].order_price;
      double_tp= hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   else
     {
      //       Print("!! TP: NÃO existe takeprift virtual");
      double_tp=PositionGetDouble(POSITION_TP);
     }
   index_=Virtual.Find((string)ticket+"PSLVcbxx");
   if(index_ >= 0)
     {
      // Comment(__LINE__,"hline_mover: ",hline_mover," index: ",index," order_name: ",virtual_lista[index].order_name," order_info: ",virtual_lista[index].order_info);
      //      Print("SL:  existe STOPLOSS virtual");
      // virtual_lista[index].order_sl=virtual_lista[index_].order_price;
      double_sl=hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   else
     {
      //        Print("!! SL: NÃO existe STOPLOSS virtual");
      double_sl=PositionGetDouble(POSITION_SL);
     }
   double price=virtual_lista[index].order_info;
   string name=virtual_lista[index].order_name;
//   double _sl= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_sl;
//   double _tp= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_tp;
//   double _sl= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_sl;
//  double _tp= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_tp;
   string symbol=virtual_lista[index].order_symbol;
   ulong _ticket=virtual_lista[index].order_ticket;
   double volume=virtual_lista[index].order_volume;
   string type=virtual_lista[index].order_type;
   int type0=virtual_lista[index].order_type0;
//  double double_sl= _sl;
//  double double_tp= _tp;
   double sl = PositionGetInteger(POSITION_TYPE) ? -(double_sl-PositionGetDouble(POSITION_PRICE_OPEN)) : double_sl -PositionGetDouble(POSITION_PRICE_OPEN) ;
   double tp = PositionGetInteger(POSITION_TYPE) ? -(double_tp-PositionGetDouble(POSITION_PRICE_OPEN)) : double_tp -PositionGetDouble(POSITION_PRICE_OPEN) ;
// Comment("SL: ",sl," | ",MathAbs(sl)," TP: ",tp);
   if(tipo=="pos_SL")
     {
      double porcc= (double) Porc(PositionGetDouble(POSITION_PRICE_OPEN), double_sl);
      StringReplace(infos, ":num", (string) num);
      StringReplace(infos, ":tipo", type0 ? "SELL" : "BUY");
      StringReplace(infos, ":vol", (string) volume);
      StringReplace(infos, ":ticket", (string) _ticket);
      StringReplace(infos, ":open", DoubleToString(price, _Digits));
      StringReplace(infos, ":pontos", DoubleToString(sl*(int) decimal, 0)); //diferença corrigida
        if(OrderCalcProfit((ENUM_ORDER_TYPE) type0, _Symbol, volume, price, price+sl, lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
        //StringReplace(infos, ":lucro", Moeda(sl, volume)); //sl = diferença corrigida
      StringReplace(infos, ":porc", DoubleToString(porcc-(porcc*2), 2)+"%"); //sl= normal
      //StringReplace(infos,":rr", DoubleToString(tp<=0 ? 0 : MathAbs(sl)/tp,2)+ "%"); //sl e tp = diferenças corrigidas
      StringReplace(infos, ":rr", DoubleToString(MathAbs(sl/tp), 2)); //sl e tp = diferenças corrigidas
     }
   if(tipo=="pos_TP")
     {
      StringReplace(infos, ":num", (string) num);
      StringReplace(infos, ":tipo", type0 ? "SELL" : "BUY");
      StringReplace(infos, ":vol", (string) volume);
      StringReplace(infos, ":ticket", (string) _ticket);
      StringReplace(infos, ":open", DoubleToString(price, _Digits));
      StringReplace(infos, ":pontos", DoubleToString(tp*(int) decimal, 0));
      if(OrderCalcProfit((ENUM_ORDER_TYPE) type0, _Symbol, volume, price, price+tp, lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
      //StringReplace(infos, ":lucro", Moeda(tp, volume));
      StringReplace(infos, ":porc", Porc(PositionGetDouble(POSITION_PRICE_OPEN), double_tp)+ "%");
      // StringReplace(infos,":rr", DoubleToString(sl>=0 ? 0 : tp/MathAbs(sl),2) + "%");
      StringReplace(infos, ":rr", DoubleToString(MathAbs(tp/sl), 2));
     }
   return infos;
  }



//+-------------------------------------------------------------------------------------------------------+
//| FUNÇÃO PARA SUBSTIUIR OS CORINGAS DOS TEXTO CUSTOMIZADO COM AS INFORMAÇÕES DA ORDEM/SL/TP VIRTUAL     |
//+-------------------------------------------------------------------------------------------------------+
string InfoUpdate::ReplaceVirtualORD(int num, int index, int ticket, string infos, string tipo)
  {
//Comment(__LINE__,"hline_mover: ",hline_mover," index: ",index," order_name: ",virtual_lista[index].order_name," order_info: ",virtual_lista[index].order_info);
//  Print("order virtual replace: ",ticket," ",tipo);
//  PositionSelectByTicket(ticket);
//Print("ticket: ",ticket," objname: ",virtual_lista[index].order_name," tp: ",virtual_lista[index].order_tp," sl: ",virtual_lista[index].order_sl);
   int index_;
   double double_tp;
   double double_sl;
   index_=Virtual.Find((string)ticket+"OTPVcbxx");
   if(index_ >= 0)
     {
      //    Print("TP: Existe takeprift virtual");      // virtual_lista[index].order_tp=virtual_lista[index_].order_price;
      double_tp= hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   else
     {
      //    Print("!! TP: NÃO existe takeprift virtual");
      double_tp=OrderGetDouble(ORDER_TP);
     }
   index_=Virtual.Find((string)ticket+"OSLVcbxx");
   if(index_ >= 0)
     {
      //    Print("SL:  existe STOPLOSS virtual");
      //  virtual_lista[index].order_sl=virtual_lista[index_].order_price;
      double_sl=hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   else
     {
      //     Print("!! SL: NÃO existe STOPLOSS virtual");
      double_sl=OrderGetDouble(ORDER_SL);
     }
   double price=virtual_lista[index].order_info;
   string name=virtual_lista[index].order_name;
//   double _sl= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_sl;
//   double _tp= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_tp;
//   double _sl= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_sl;
//  double _tp= hline_mover ? virtual_lista[index].order_info : virtual_lista[index].order_tp;
   string symbol=virtual_lista[index].order_symbol;
   ulong _ticket=virtual_lista[index].order_ticket;
   double volume=virtual_lista[index].order_volume;
   string type=virtual_lista[index].order_type;
   int type0=virtual_lista[index].order_type0;
//  double double_sl= _sl;
//  double double_tp= _tp;
   double sl = OrderGetInteger(ORDER_TYPE) ? -(double_sl-OrderGetDouble(ORDER_PRICE_OPEN)) : double_sl -OrderGetDouble(ORDER_PRICE_OPEN) ;
   double tp = OrderGetInteger(ORDER_TYPE) ? -(double_tp-OrderGetDouble(ORDER_PRICE_OPEN)) : double_tp -OrderGetDouble(ORDER_PRICE_OPEN) ;
//  Comment("SL: ",MathAbs(sl)," TP: ",tp);
   if(tipo=="ord_open")
     {
      //  Print("ordem virtual atualizar!");
      StringReplace(infos, ":num", (string) num);
      StringReplace(infos, ":tipo", TipoOrder((string) type0));
      StringReplace(infos, ":vol", (string) volume);
      StringReplace(infos, ":open", DoubleToString(price, _Digits));
      StringReplace(infos, ":lucro", "");
      StringReplace(infos, ":ticket", (string) _ticket);
     }
   if(tipo=="ord_SL")
     {
      StringReplace(infos, ":num", (string) num);
      StringReplace(infos, ":tipo", TipoOrder((string) type0));
      StringReplace(infos, ":vol", (string) volume);
      StringReplace(infos, ":ticket", (string) _ticket);
      StringReplace(infos, ":open", DoubleToString(price, _Digits));
      StringReplace(infos, ":pontos", DoubleToString(sl*(int) decimal, 0)); //diferença corrigida
      if(OrderCalcProfit((ENUM_ORDER_TYPE) type0, _Symbol, volume, price, price+sl, lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
      //StringReplace(infos, ":lucro", Moeda(sl, volume)); //sl = diferença corrigida
      StringReplace(infos, ":porc", Porc(OrderGetDouble(ORDER_PRICE_OPEN), double_sl)+ "%"); //sl= normal
      //StringReplace(infos,":rr", DoubleToString(tp<=0 ? 0 : MathAbs(sl)/tp,2)+ "%"); //sl e tp = diferenças corrigidas
      StringReplace(infos, ":rr", DoubleToString(MathAbs(sl/tp), 2)); //sl e tp = diferenças corrigidas
     }
   if(tipo=="ord_TP")
     {
      StringReplace(infos, ":num", (string) num);
      StringReplace(infos, ":tipo", TipoOrder((string) type0));
      StringReplace(infos, ":vol", (string) volume);
      StringReplace(infos, ":ticket", (string) _ticket);
      StringReplace(infos, ":open", DoubleToString(price, _Digits));
      StringReplace(infos, ":pontos", DoubleToString(tp*(int) decimal, 0));
      if(OrderCalcProfit((ENUM_ORDER_TYPE) type0, _Symbol, volume, price, price+tp, lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
      //StringReplace(infos, ":lucro", Moeda(tp, volume));
      StringReplace(infos, ":porc", Porc(OrderGetDouble(ORDER_PRICE_OPEN), double_tp)+ "%");
      // StringReplace(infos,":rr", DoubleToString(sl>=0 ? 0 : tp/MathAbs(sl),2) + "%");
      StringReplace(infos, ":rr", DoubleToString(MathAbs(tp/sl), 2));
     }
   if(tipo=="ord_open")
     {
      StringReplace(infos, ":num", (string) num);
      StringReplace(infos, ":tipo", TipoOrder((string) type0));
      StringReplace(infos, ":vol", (string) volume);
      StringReplace(infos, ":open", DoubleToString(price, _Digits));
      StringReplace(infos, ":lucro", "");
      StringReplace(infos, ":ticket", (string) _ticket);
     }
   return infos;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int InfoUpdate::Normalizar(string objname)
  {
   int index=Virtual.Find(objname);
   if(index>=0)
     {
      int type=virtual_lista[index].order_type0;
      double open=virtual_lista[index].order_open;
      double sl=virtual_lista[index].order_sl;
      double tp=virtual_lista[index].order_tp;
      double _sl=type?-(sl-open):sl-open;
      double _tp=type?-(tp-open):tp-open;
      virtual_lista[index].order_sl_rr=_sl;
      virtual_lista[index].order_tp_rr=_tp;
     }
   return(index);
  }

//+----------------------------------------------------------------------------------------------------------------+
//| FUNÇÃO PARA SUBSTIUIR OS CORINGAS DOS TEXTO CUSTOMIZADO COM AS INFORMAÇÕES DA POSIÇAO/SL/TP/ORDENS NA PEDRA    |
//+----------------------------------------------------------------------------------------------------------------+
string InfoUpdate::ReplacePedraPOS(int ticket, string infos, string tipo)
  {
   int index_;
   double double_sl=PositionGetDouble(POSITION_SL);
   double double_tp=PositionGetDouble(POSITION_TP);
   index_=Virtual.Find((string) ticket+"PTPVcbxx");
   if(index_ >= 0)
     {
      double_tp=hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   index_=Virtual.Find((string) ticket+"PSLVcbxx");
   if(index_ >=0)
     {
      double_sl=hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   double sl = PositionGetInteger(POSITION_TYPE) ? -(double_sl-PositionGetDouble(POSITION_PRICE_OPEN)) : double_sl -PositionGetDouble(POSITION_PRICE_OPEN) ;
   double tp = PositionGetInteger(POSITION_TYPE) ? -(double_tp-PositionGetDouble(POSITION_PRICE_OPEN)) : double_tp -PositionGetDouble(POSITION_PRICE_OPEN) ;
   if(tipo == "pos_open")
     {
      //    Print(__LINE__," tp: ",tp == 0 ? 1 : -tp," sl: ",sl == 0 ? 1 : sl);
      //  string rr=DoubleToString(tp == 0 ? 1 : tp/sl == 0 ? 1 : sl,2)+"%";
      StringReplace(infos, ":num", (string) NumeroDaPosicao(ticket));
      StringReplace(infos, ":tipo", PositionGetInteger(POSITION_TYPE) ? "SELL" : "BUY");
      StringReplace(infos, ":vol", (string) PositionGetDouble(POSITION_VOLUME));
      StringReplace(infos, ":ticket", (string) PositionGetInteger(POSITION_TICKET));
      StringReplace(infos, ":open", DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), _Digits));
      StringReplace(infos, ":lucro", DoubleToString(PositionGetDouble(POSITION_PROFIT), 2)+" $");
      //StringReplace(infos,":rr",rr);
     }
   double tpp;
   if(tipo=="pos_SL")
     {
      double porcc= (double) Porc(PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_SL));
      if(tp == 0)
        {
         return("0");
        }
      else
        {
         tpp=tp;
        }
      StringReplace(infos, ":num", (string) NumeroDaPosicao(ticket));
      StringReplace(infos, ":tipo", PositionGetInteger(POSITION_TYPE) ? "SELL" : "BUY");
      StringReplace(infos, ":vol", (string) PositionGetDouble(POSITION_VOLUME));
      StringReplace(infos, ":ticket", (string) PositionGetInteger(POSITION_TICKET));
      StringReplace(infos, ":open", DoubleToString(PositionGetDouble(POSITION_SL), _Digits));
      StringReplace(infos, ":pontos", DoubleToString(sl*(int) decimal, 0));
      if(OrderCalcProfit((ENUM_ORDER_TYPE) PositionGetInteger(POSITION_TYPE), _Symbol, PositionGetDouble(POSITION_VOLUME), PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_SL), lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
      //StringReplace(infos, ":lucro", Moeda(sl, PositionGetDouble(POSITION_VOLUME)));
      // StringReplace(infos,":porc",Porc(PositionGetDouble(POSITION_PRICE_OPEN),PositionGetDouble(POSITION_SL))+ "%");
      StringReplace(infos, ":porc", DoubleToString(porcc-(porcc*2), 2)+"%"); //sl= normal
      StringReplace(infos, ":rr", DoubleToString(MathAbs(sl/tpp), 2));
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   double sll;
   if(tipo=="pos_TP")
     {
      if(sl == 0)
        {
         return("0");
        }
      else
        {
         sll=sl;
        }
      StringReplace(infos, ":num", (string) NumeroDaPosicao(ticket));
      StringReplace(infos, ":tipo", PositionGetInteger(POSITION_TYPE) ? "SELL" : "BUY");
      StringReplace(infos, ":vol", (string) PositionGetDouble(POSITION_VOLUME));
      StringReplace(infos, ":ticket", (string) PositionGetInteger(POSITION_TICKET));
      StringReplace(infos, ":open", DoubleToString(PositionGetDouble(POSITION_TP), _Digits));
      StringReplace(infos, ":pontos", DoubleToString(tp*(int) decimal, 0));
      if(OrderCalcProfit((ENUM_ORDER_TYPE) PositionGetInteger(POSITION_TYPE), _Symbol, PositionGetDouble(POSITION_VOLUME), PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_TP), lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
      //StringReplace(infos, ":lucro", Moeda(tp, PositionGetDouble(POSITION_VOLUME)));
      StringReplace(infos, ":porc", Porc(PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_TP))+ "%");
      StringReplace(infos, ":rr", DoubleToString(MathAbs(tp/sll), 2));
     }
   return(infos);
  }
//+----------------------------------------------------------------------------------------------------------------+
//| FUNÇÃO PARA SUBSTIUIR OS CORINGAS DOS TEXTO CUSTOMIZADO COM AS INFORMAÇÕES DA ORDER/SL/TP/ORDENS NA PEDRA      |
//+----------------------------------------------------------------------------------------------------------------+
string InfoUpdate::ReplacePedraORD(int ticket, string infos, string tipo)
  {
   int index_;
   double double_sl=OrderGetDouble(ORDER_SL);
   double double_tp=OrderGetDouble(ORDER_TP);
   index_=Virtual.Find((string) ticket+"OTPVcbxx");
   if(index_ >= 0)
     {
      double_tp=hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   index_=Virtual.Find((string) ticket+"OSLVcbxx");
   if(index_ >=0)
     {
      double_sl=hline_mover ? virtual_lista[index_].order_info : virtual_lista[index_].order_price;
     }
   double sl = OrderGetInteger(ORDER_TYPE) ? -(double_sl-OrderGetDouble(ORDER_PRICE_OPEN)) : double_sl -OrderGetDouble(ORDER_PRICE_OPEN);
   double tp = OrderGetInteger(ORDER_TYPE) ? -(double_tp-OrderGetDouble(ORDER_PRICE_OPEN)) : double_tp -OrderGetDouble(ORDER_PRICE_OPEN);
   if(tipo=="ord_open")
     {
      //   Print(__LINE__," tp: ",tp," sl: ",sl);
      string rr=DoubleToString(-tp == 0 ? 1 : -tp/sl == 0 ? 1 : sl, 2)+"%";
      StringReplace(infos, ":num", (string) NumeroDaOrdem(ticket));
      StringReplace(infos, ":tipo", TipoOrder((string) OrderGetInteger(ORDER_TYPE)));
      StringReplace(infos, ":vol", (string) OrderGetDouble(ORDER_VOLUME_INITIAL));
      StringReplace(infos, ":open", DoubleToString(OrderGetDouble(ORDER_PRICE_OPEN), _Digits));
      StringReplace(infos, ":lucro", "");
      StringReplace(infos, ":ticket", (string) OrderGetInteger(ORDER_TICKET));
      StringReplace(infos, ":rr", rr);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(tipo=="ord_SL")
     {
      StringReplace(infos, ":num", (string) NumeroDaOrdem(ticket));
      StringReplace(infos, ":tipo", TipoOrder((string) OrderGetInteger(ORDER_TYPE)));
      StringReplace(infos, ":vol", (string) OrderGetDouble(ORDER_VOLUME_INITIAL));
      StringReplace(infos, ":ticket", (string) OrderGetInteger(ORDER_TICKET));
      StringReplace(infos, ":open", DoubleToString(OrderGetDouble(ORDER_SL), _Digits));
      StringReplace(infos, ":pontos", DoubleToString(sl*(int) decimal, 0));
      StringReplace(infos, ":lucro", Moeda(sl, OrderGetDouble(ORDER_VOLUME_INITIAL)));
      if(OrderCalcProfit((ENUM_ORDER_TYPE) OrderGetInteger(ORDER_TYPE), _Symbol, OrderGetDouble(ORDER_VOLUME_CURRENT), OrderGetDouble(ORDER_PRICE_CURRENT), OrderGetDouble(ORDER_TP), lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
      //StringReplace(infos, ":lucro", Moeda(sl, OrderGetDouble(ORDER_VOLUME_INITIAL)));
      StringReplace(infos, ":porc", Porc(OrderGetDouble(ORDER_PRICE_OPEN), OrderGetDouble(ORDER_TP))+ "%");
      StringReplace(infos, ":rr", DoubleToString(MathAbs(sl/tp), 2));
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(tipo=="ord_TP")
     {
      StringReplace(infos, ":num", (string) NumeroDaOrdem(ticket));
      StringReplace(infos, ":tipo", TipoOrder((string) OrderGetInteger(ORDER_TYPE)));
      StringReplace(infos, ":vol", (string) OrderGetDouble(ORDER_VOLUME_INITIAL));
      StringReplace(infos, ":ticket", (string) OrderGetInteger(ORDER_TICKET));
      StringReplace(infos, ":open", DoubleToString(OrderGetDouble(ORDER_TP), _Digits));
      StringReplace(infos, ":pontos", DoubleToString(tp*(int) decimal, 0));
      if(OrderCalcProfit((ENUM_ORDER_TYPE) OrderGetInteger(ORDER_TYPE), _Symbol, OrderGetDouble(ORDER_VOLUME_CURRENT), OrderGetDouble(ORDER_PRICE_CURRENT), OrderGetDouble(ORDER_TP), lucro))
        {
         StringReplace(infos, ":lucro", (string) lucro);
        }
      //StringReplace(infos, ":lucro", Moeda(tp, OrderGetDouble(ORDER_VOLUME_INITIAL)));
      StringReplace(infos, ":porc", Porc(OrderGetDouble(ORDER_PRICE_OPEN), OrderGetDouble(ORDER_TP))+ "%");
      StringReplace(infos, ":rr", DoubleToString(MathAbs(tp/sl), 2));
     }
   return infos;
  }
//+--------------------------------------------------------------------------------------+
//| FUNÇÃO AUXILIAR PARA TROCAR O NUMERO DO ENUM_TYPE_ORDER PARA STRING CORRESPONDENTE   |
//+--------------------------------------------------------------------------------------+
string InfoUpdate::TipoOrder(string tipoordem)
  {
   StringReplace(tipoordem, (string) 0, "BUY order");
   StringReplace(tipoordem, (string) 1, "SELL order");
   StringReplace(tipoordem, (string) 2, "BUY LIMIT");
   StringReplace(tipoordem, (string) 3, "SELL LIMIT");
   StringReplace(tipoordem, (string) 4, "BUY STOP");
   StringReplace(tipoordem, (string) 5, "SELL STOP");
   StringReplace(tipoordem, (string) 7, "SELL STOP LIMIT");
   StringReplace(tipoordem, (string) 8, "BUY STOP LIMIT");
   StringReplace(tipoordem, (string) 9, "CLOSE BY");
   return tipoordem;
  }
//+----------------------------------------------------------------------+
//|  FUNÇÃO AUXILIAR PARA RETORNAR O NÚMERO DA POSIÇÃO DE UMA POSIÇÃO    |
//+----------------------------------------------------------------------+
int InfoUpdate::NumeroDaPosicao(int ticket)
  {
   int i = PositionsTotal()-1;
   for(i; i >= 0; i--)
      if(PositionGetTicket(i) == ticket)
        {
         break;
        }
   PositionSelectByTicket(ticket);
   return(i);
  }
//+---------------------------------------------------------------------+
//|  FUNÇÃO AUXILIAR PARA RETORNAR O NÚMERO DA POSIÇÃO DE UMA ORDEM     |
//+---------------------------------------------------------------------+
int InfoUpdate::NumeroDaOrdem(int ticket)
  {
   int i = OrdersTotal()-1;
   for(i; i >= 0; i--)
      if(OrderGetTicket(i) == ticket)
        {
         break;
        }
   return(i);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
