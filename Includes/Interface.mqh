//+------------------------------------------------------------------+
//| Interface.mqh                                                    |
//| Telegram: @grupomql5 & @comunidademql5 // http://t.me/grupomql5  |
//| Por Pedro                                                        |
//+------------------------------------------------------------------+
#property copyright  "Telegram: @grupomql5 || @comunidademql5 || por Pedro em 06.04.2021"
#property description "Interface Gráfica dos Botões - Em 17.03.2021"
#property version     "1.0"
#include <../InfoUpdate.mqh>;
#include <../Acoplamento.mqh>;
//+------------------------------------------------------------------+
//| CLASSE PARA CRIAR, MOVER E APAGAR A INTERFACE GRÁFICA            |
//+------------------------------------------------------------------+
class CObjecto
  {
protected:
                     CObjecto(void) { }
                    ~CObjecto(void) { };
public:
   void              Criar(string nome,double PriceOpen);
   void              Apagar(string ticket, int tipo);
   void              Mover(string nome,int x,int y);
   void              MoverV(string objname,double PriceOpen);
   void              Minimizar();
   void              CliqueDuplo();
   void              Deselecionar();
   void              Selecionar(string sparam_);
   void              TrazerParaFrente();
   void              Arrastar(int mousex, int mousey);
   void              AlterarTexto(int chart_ID,string name8,string text,string name7);
  };

//+-------------------------------------------------------------------------------------------------------+
//|  CLASSE PARA CONTROLAR/RELACIONAR A INTERFACE GRÁFICA DAS ORDENS/POSIÇÕES                             |
//+-------------------------------------------------------------------------------------------------------+
class CInterface:public CObjecto
  {
public:
                     CInterface() {};
                    ~CInterface() {};
   void              Relacionar_Ordens(double valor);
   void              Relacionar_Posicoes(ulong valor);
   void              Verificar_Valor(int index, string objname, double PriceOpen);
   void              Atualizar();
   void              VirtualClique(string objname);
   void              VirtualOnTick();
   void              VirtualInterface();
   void              VerificarCoordendas();
  };

CInterface Interface;
class CClique
  {
public:
                     CClique(void) {};
                    ~CClique(void) {};
   void              Fechar();
   void              Arrasta();
  };
CClique CloseButtonX;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CInterface::VirtualInterface()
  {
   Virtual.xInterface();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CInterface::VirtualOnTick()
  {
   Virtual.OnTick();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CInterface::VirtualClique(string objname)
  {
   Virtual.VirtualClique(objname);
  }
//+------------------------------------------------------------------+
//|  FUNÇÃO PARA ATUALIZAR A INTERFACE GRÁFICA                       |
//+------------------------------------------------------------------+
void CInterface::Atualizar()
  {
   VirtualInterface();
   Relacionar_Posicoes(0);
   Relacionar_Ordens(0);
   Info.Update();
   ChartRedraw();
  }

//+------------------------------------------------------------------+
//| FUNÇÃO DA CLASSE PARA MOVER A INTERFACE GRÁFICA                  |
//+------------------------------------------------------------------+
void CObjecto::Mover(string nome,int x,int y)
  {
   ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,y);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| FUNÇÃO DA CLASSE PARA CRIAR A INTERFACE GRÁFICA                  |
//+------------------------------------------------------------------+
void CObjecto::Criar(string objname,double PriceOpen)
  {
   string objnameRecClose=objname+"1";
   string objnameLabClose=objname+"2";
   string objnameRecSL=objname+"3";
   string objnameLabSL=objname+"4";
   string objnameRecTP=objname+"5";
   string objnameLabTP=objname+"6";
   string objnameRecPontos=objname+"7";
   string objnameLabPontos=objname+"8";
   int PosicaoInicialB1=fgrafico-_larguraB1;
   int PosicaoInicialB2=fgrafico-_larguraB1-_larguraB2;
   int PosicaoInicialB3=fgrafico-_larguraB1-_larguraB2-_larguraB3;
   int PosicaoInicialB4=fgrafico-_larguraB1-_larguraB2-_larguraB3-_larguraB4;
   string B6_label=StringFind(objname,"Vcbxx") > 0 ? "V" : "#";

   cor_fundo=clrLightGoldenrod;
   cor_borda=clrDarkSeaGreen;
   cor_texto=clrBlack;


   Rectangle(objnameRecClose,fgrafico-_xB1,b-_yB1+1,_larguraB1,_alturaB1);
   Label(objnameLabClose,fgrafico-_xL1+6,b-_yL1+1,11,"x");
   Rectangle(objnameRecSL,fgrafico-_xB2,b-_yB2+1,_larguraB2,_alturaB2);
   Label(objnameLabSL,fgrafico-_xL2+8,b-_yL2+2,13,"+");
   Rectangle(objnameRecTP,fgrafico-_xB3,b-_yB3+1,_larguraB3,_alturaB3);
   Label(objnameLabTP,fgrafico-_xL3+6,b-_yL3+1,8,B6_label);


   if(StringFind(objname,"C") > 0)
     {
      //  HLineCreate(0,objname,0,PriceOpen,clrFireBrick,STYLE_DASHDOT,1,false,false,true,0);
     }
   if(StringFind(objname,"OCL") >= 0)
     {
      cor_fundo=ord_cor_fundo;
      cor_clique=ord_cor_clique;
      cor_borda=ord_cor_borda;
      cor_texto=ord_cor_texto;
      tooltip_=ord_texto_mini;
     }
   if(StringFind(objname,"OSL") >= 0)
     {
      cor_fundo=ord_sl_cor_fundo;
      cor_clique=ord_sl_cor_clique;
      cor_borda=ord_sl_cor_borda;
      cor_texto=ord_sl_cor_texto;
      tooltip_=ord_texto_mini;
     }
   if(StringFind(objname,"OTP") >= 0)
     {
      cor_fundo=ord_tp_cor_fundo;
      cor_clique=ord_tp_cor_clique;
      cor_borda=ord_tp_cor_borda;
      cor_texto=ord_tp_cor_texto;
     }
   if(StringFind(objname,"PCL") >= 0)
     {
      cor_fundo=pos_cor_fundo;
      cor_clique=pos_cor_clique;
      cor_borda=pos_cor_borda;
      cor_texto=pos_cor_texto;
      tooltip_=pos_texto_mini;
     }
   if(StringFind(objname,"PSL") >= 0)
     {
      cor_fundo=pos_sl_cor_fundo;
      cor_clique=pos_sl_cor_clique;
      cor_borda=pos_sl_cor_borda;
      cor_texto=pos_sl_cor_texto;
      tooltip_=pos_sl_texto_mini;
     }
   if(StringFind(objname,"PTP") >= 0)
     {
      cor_fundo=pos_tp_cor_fundo;
      cor_clique=pos_tp_cor_clique;
      cor_borda=pos_tp_cor_borda;
      cor_texto=pos_tp_cor_texto;
      tooltip_=pos_tp_texto_mini;
     }
   if(StringFind(objname,"Vcbxx") > 0)
     {
      //  HLineCreate(0,objname,0,PriceOpen,clrFireBrick,STYLE_DASHDOT,1,false,false,true,0);
     }

   Rectangle(objnameRecPontos,fgrafico-_xB4,b-_yB4+1,_larguraB4,_alturaB4);
   Label(objnameLabPontos,fgrafico-_xL4+7,b-_yL4+1,8,"...");
   Acoplados_add(objnameRecPontos);
  }

//+--------------------------------------------------------------+
//| FUNÇÃO DA CLASSE PARA apagar A INTERFACE GRÁFICA (BOTÕES)    |
//+--------------------------------------------------------------+
void CObjecto::Apagar(string ticket,int tipo)
  {
   for(int i=1; i<9; i++)
     {
      string ticket2=ticket+(string)i;
      if(!tipo)
        {
         ObjectDelete(0,(string) ticket2);
         ChartRedraw();
        }
     }
  }
//+-----------------------------------------------------------------------------------------+
//| FUNÇÃO DA CLASSE PARA RELACIONAR AS ORDENS COM A INTERFACE GRÁFICA DOS BOTÕES           |                                                                  |
//+-----------------------------------------------------------------------------------------+
void CInterface::Relacionar_Ordens(double valor)
  {
   fgrafico=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   int inicio=0;
   int total=OrdersTotal();
   for(int i=inicio; i<=total-1; i++)
     {
      ulong ticket = OrderGetTicket(i);
      string ticket_symbol=OrderGetString(ORDER_SYMBOL);
      if(ticket_symbol==ChartSymbol(0))
        {
         if(ticket>0)
           {
            double ordemPriceOpen = OrderGetDouble(ORDER_PRICE_OPEN);
            double ordemStopLoss =  OrderGetDouble(ORDER_SL);
            double ordemTP =  OrderGetDouble(ORDER_TP);
            //  string ordemPriceHighlight = (string) ordemPriceOpen+"HighlightX";
            //    string ordemSLHighlight = (string) ordemStopLoss+"HighlightX";
            //    string ordemTPHighlight = (string) ordemTP+"HighlightX";
            if(!valor)
              {
               Verificar_Valor(i,(string) ticket+"OCLcbxx",ordemPriceOpen);
               if(OrderGetDouble(ORDER_SL))
                 {
                  Verificar_Valor(i,(string) ticket+"OSLcbxx",ordemStopLoss);
                 }
               if(OrderGetDouble(ORDER_TP))
                 {
                  Verificar_Valor(i,(string) ticket+"OTPcbxx",ordemTP);
                 }
               Info.Update_Ordens();
              }
            // if(valor == ordemPriceOpen)
            //   {
            //    HLineCreate(0,ordemPriceHighlight,0,ordemPriceOpen,corLinhaNegocio,STYLE_SOLID,3,true,
            //                false,true,false);
            //    if(ordemStopLoss)
            //      {
            //       HLineCreate(0,ordemSLHighlight,0,ordemStopLoss,corLinhaStopLoss,STYLE_SOLID,3,true,
            //                   false,true,false);
            //      }
            //    if(ordemTP)
            //      {
            //       HLineCreate(0,ordemTPHighlight,0,ordemTP,corLinhaTakeProfit,STYLE_SOLID,3,true,
            //                   false,true,false);
            //      }
            //    PriceOpenAntigoOrder=(double) ordemPriceHighlight;
            //    PriceStopAntigoOrder=(double) ordemSLHighlight;
            //    PriceTPAntigoOrder=(double) ordemTPHighlight;
            //   }
            //}
           }
        }
     }
  }
//+-----------------------------------------------------------------------------------------+
//| FUNÇÃO DA CLASSE PARA RELACIONAR AS POSIÇÕES COM A INTERFACE GRÁFICA DOS BOTÕES         |                                                                  |
//+-----------------------------------------------------------------------------------------+
void CInterface::Relacionar_Posicoes(ulong valor)
  {
   fgrafico=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   int inicio=0;
   int total=PositionsTotal();
   for(int i=inicio; i<=total-1; i++)
     {
      string ticket_symbol=PositionGetSymbol(i);
      if(ticket_symbol==ChartSymbol(0))
        {
         ulong ticket = PositionGetTicket(i);
         if(ticket>0)
           {
            double posPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
            double posStopLoss =  PositionGetDouble(POSITION_SL);
            double posTP =  PositionGetDouble(POSITION_TP);
            int posVolume = (int) PositionGetDouble(POSITION_VOLUME);
            //  string PosPriceHighlight = (string) posPriceOpen+"HighlightX";
            //   string PosSLHighlight = (string) posStopLoss+"HighlightX";
            //   string PosTPHighlight = (string) posTP+"HighlightX";
            if(!valor)
              {
               Verificar_Valor(i,(string) ticket+"PCLcbxx",posPriceOpen);
               string SL_virtual_name = (string) ticket+"PSLVcbxx";
               string TP_virtual_name = (string) ticket+"PTPVcbxx";
               if(PositionGetDouble(POSITION_SL) && Virtual.Find(SL_virtual_name) < 0)
                  // if(PositionGetDouble(POSITION_SL))
                 {
                  Verificar_Valor(i,(string) ticket+"PSLcbxx",posStopLoss);
                 }
               if(PositionGetDouble(POSITION_TP) && Virtual.Find(TP_virtual_name) < 0)
                  //  if(PositionGetDouble(POSITION_TP))
                 {
                  Verificar_Valor(i,(string) ticket+"PTPcbxx",posTP);
                 }
               Info.Update_Posicoes();
              }
            //if(valor == posPriceOpen)
            //  {
            //   HLineCreate(0,PosPriceHighlight,0,posPriceOpen,corLinhaNegocio,STYLE_SOLID,3,true,
            //               false,true,false);
            //   if(posStopLoss)
            //     {
            //      HLineCreate(0,PosSLHighlight,0,posStopLoss,corLinhaStopLoss,STYLE_SOLID,3,true,
            //                  false,true,false);
            //     }
            //   if(posTP)
            //     {
            //      HLineCreate(0,PosTPHighlight,0,posTP,corLinhaTakeProfit,STYLE_SOLID,3,true,
            //                  false,true,false);
            //     }
            //   PriceOpenAntigo=(double) PosPriceHighlight;
            //   PriceStopAntigo=(double) PosSLHighlight;
            //   PriceTPAntigo=(double) PosTPHighlight;
            //  }
           }
        }
     }
  }
//+--------------------------------------------------------------------------------------------------------+
//| FUNÇÃO QUE QUANDO EXECUTADA DECIDE SE É CASO DE CRIAR A INTERFACE GRÁFICA (QUANDO AINDA NÃO EXISTE)    |
//| OU SE É PARA ALTERAR A POSIÇÃO (X E Y) DOS BOTÕES                                                      |
//+--------------------------------------------------------------------------------------------------------+
void CInterface::Verificar_Valor(int index,string objname,double PriceOpen)
  {
   int coordenadas = ChartTimePriceToXY(0,0,TimeCurrent(),PriceOpen,a,b);
   objnamebotao1 = objname+"1";
   if(ObjectFind(0,objnamebotao1) >= 0)
     {
      //   Print("já existe: mover...");
      objnamebotao2 = objname+"2";
      objnamebotao3 = objname+"3";
      objnamebotao4 = objname+"4";
      objnamebotao5 = objname+"5";
      objnamebotao6 = objname+"6";
      objnamebotao7 = objname+"7";
      objnamebotao8 = objname+"8";
      int PosicaoInicialB1=fgrafico-_larguraB1;
      int PosicaoInicialB2=fgrafico-_larguraB1-_larguraB2;
      int PosicaoInicialB3=fgrafico-_larguraB1-_larguraB2-_larguraB3;
      int PosicaoInicialB4=fgrafico-_larguraB1-_larguraB2-_larguraB3-_larguraB4;
      int PosicaoAtualB1 = (int) ObjectGetInteger(0,objnamebotao1,OBJPROP_XDISTANCE);
      int PosicaoAtualB2 = (int) ObjectGetInteger(0,objnamebotao3,OBJPROP_XDISTANCE);
      int PosicaoAtualB3 = (int) ObjectGetInteger(0,objnamebotao5,OBJPROP_XDISTANCE);
      int PosicaoAtualB4 = (int) ObjectGetInteger(0,objnamebotao7,OBJPROP_XDISTANCE);
      int posicaografico1 = (PosicaoInicialB1 == PosicaoAtualB1) ? PosicaoInicialB1 : PosicaoAtualB1;
      int posicaografico2 = (PosicaoInicialB2 == PosicaoAtualB2) ? PosicaoInicialB2 : PosicaoAtualB2;
      int posicaografico3 = (PosicaoInicialB3 == PosicaoAtualB3) ? PosicaoInicialB3 : PosicaoAtualB3;
      int posicaografico4 = (PosicaoInicialB4 == PosicaoAtualB4) ? PosicaoInicialB4 : PosicaoAtualB4;
      int bb=12;

      ObjectSetDouble(0,objname,OBJPROP_PRICE,PriceOpen);
      Mover(objnamebotao1,PosicaoInicialB1,b-bb);
      Mover(objnamebotao2,PosicaoInicialB1+3,b-(bb+6));
      Mover(objnamebotao3,PosicaoInicialB2,b-bb);
      Mover(objnamebotao4,PosicaoInicialB2+4,b-(bb+5));
      Mover(objnamebotao5,PosicaoInicialB3,b-bb);
      Mover(objnamebotao6,PosicaoInicialB3+4,b-(bb+2));
      if(!botao78_habilitado_para_arrastar)
        {
         Mover(objnamebotao7,posicaografico4,b-bb);
         Mover(objnamebotao8,posicaografico4+2,b-(bb+2));
        }
     }
   else
     {
      //string name=StringSubstr(objname,0,7);
      //if(Virtual.Find(name+"PSLVcbxx") < 0 || Virtual.Find(name+"PTPVcbxx") < 0)
      // Print("não existe: criar...");
      Criar(objname,PriceOpen);
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| FUNÇÃO PARA DIMINUIR A LARGURA DA BARRA DE INFORMAÇÕES           |
//+------------------------------------------------------------------+
void CObjecto::Minimizar()
  {
   if(ObjectGetInteger(0,objname7_,OBJPROP_XSIZE) != largura_1_barra) /////////MAXIMIZAR
     {
      ObjectSetString(0,objname4_,OBJPROP_TEXT,"-");
      if(StringFind(objname4_,"PCL",0) > 0 || StringFind(objname4_,"PCL",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,largura_1_barra);
         ObjectSetInteger(0,objname7_,OBJPROP_XDISTANCE,x7_);
         ObjectSetInteger(0,objname8_,OBJPROP_XDISTANCE,x7_+2);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraPOS((int)Ac_0_,pos_texto_mini,"pos_open"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,pos_texto_grande);
        }
      if(StringFind(objname4_,"OCL",0) > 0 || StringFind(objname4_,"OCL",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,largura_1_barra);
         ObjectSetInteger(0,objname7_,OBJPROP_XDISTANCE,x7_);
         ObjectSetInteger(0,objname8_,OBJPROP_XDISTANCE,x7_+2);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraORD((int) Ac_0_,ord_texto_mini,"ord_open"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,ord_texto_grande);
        }
      if(StringFind(objname4_,"SL",0) > 0 || StringFind(objname4_,"SL",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,largura_1_barra);
         ObjectSetInteger(0,objname7_,OBJPROP_XDISTANCE,x7_);
         ObjectSetInteger(0,objname8_,OBJPROP_XDISTANCE,x7_+2);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraPOS((int) Ac_0_,pos_sl_texto_mini,"pos_SL"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,pos_sl_texto_grande);
        }
      if(StringFind(objname4_,"TP",0) > 0 || StringFind(objname4_,"TP",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,largura_1_barra);
         ObjectSetInteger(0,objname7_,OBJPROP_XDISTANCE,x7_);
         ObjectSetInteger(0,objname8_,OBJPROP_XDISTANCE,x7_+2);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraPOS((int) Ac_0_,pos_tp_texto_mini,"pos_TP"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,pos_tp_texto_grande);
        }
     }
   else
     {
      ObjectSetString(0,objname4_,OBJPROP_TEXT,"+"); ////////////MINIMIZAR
      if(StringFind(objname4_,"PCL",0) > 0 || StringFind(objname4_,"PCL",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,_larguraB4);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraPOS((int) Ac_0_,pos_texto_grande,"pos_open"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,pos_texto_mini);
        }
      if(StringFind(objname4_,"OCL",0) > 0 || StringFind(objname4_,"OCL",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,_larguraB4);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraORD((int) Ac_0_,ord_texto_grande,"ord_open"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,ord_texto_mini);
        }
      if(StringFind(objname4_,"SL",0) > 0 || StringFind(objname4_,"SL",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,_larguraB4);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraPOS((int) Ac_0_,pos_sl_texto_grande,"pos_SL"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,pos_sl_texto_mini);
        }
      if(StringFind(objname4_,"TP",0) > 0 || StringFind(objname4_,"TP",0) > 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XSIZE,_larguraB4);
         ObjectSetString(0,objname8_,OBJPROP_TEXT,Info.ReplacePedraPOS((int) Ac_0_,pos_tp_texto_grande,"pos_TP"));
         ObjectSetString(0,objname8_,OBJPROP_TOOLTIP,pos_tp_texto_mini);
        }
     }
   Info.Update();
   ChartRedraw();
  }
//+----------------------------------------------------------------------------------------+
//| FUNÇÃO PARA DESATIVAR O MOVIMENTO DA BARRA DE INFORMAÇÕES COM O MOVIMENTO DO MOUSE     |
//+----------------------------------------------------------------------------------------+
void CObjecto::Deselecionar()
  {
   if(botao78_habilitado_para_arrastar)
     {
      objecto_selecionado_para_arrastar=(string) 0;
      botao78_habilitado_para_arrastar=0;
      Selecionar("0");
      ObjectSetInteger(0,objname7_,OBJPROP_BGCOLOR,cor_fundo);
      ChartRedraw();
     }
  }
//+------------------------------- -------------------------------------------------------------------+
//| FUNÇÃO PARA DEIXAR INFORMAÇÕES DE DETERMINADO OBJETO GRÁFICO NA MEMÓRIA PARA FUTURA MANIPULAÇÃO   |
//+---------------------------------------------------------------------------------------------------+
void CObjecto::Selecionar(string sparam_)
  {
   int pos=StringFind(sparam_,"Vcbxx",0) > 0 ? 4 : 3;
   fgrafico=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   Ac_0_= StringSubstr(sparam_,0,StringFind(sparam_,"cbxx",0)-pos);
   Ac_1_= StringSubstr(sparam_,StringFind(sparam_,"cbxx",0)-pos,StringLen(sparam_));
   Ac_2_=StringSubstr(Ac_1_,0,StringLen(Ac_1_)-1);
   objname3_=Ac_0_+Ac_2_+"3";
   objname4_=Ac_0_+Ac_2_+"4";
   objname5_=Ac_0_+Ac_2_+"5";
   objname7_=Ac_0_+Ac_2_+"7";
   objname8_=Ac_0_+Ac_2_+"8";
   limite_= (int) ObjectGetInteger(0,objname4_,OBJPROP_XDISTANCE);
   x7_largura_= (int) ObjectGetInteger(0,objname7_,OBJPROP_XSIZE);
   x7_= (int) ObjectGetInteger(0,objname7_,OBJPROP_XDISTANCE);
   x8_= (int) ObjectGetInteger(0,objname8_,OBJPROP_XDISTANCE);
   y7_= (int) ObjectGetInteger(0,objname7_,OBJPROP_YDISTANCE);
   y8_= (int) ObjectGetInteger(0,objname8_,OBJPROP_YDISTANCE);
   t8_= ObjectGetString(0,objname8_,OBJPROP_TEXT);
   t8_cor_= (color) ObjectGetInteger(0,objname8_,OBJPROP_COLOR);
  }
//+-----------------------------------------------------------------------------------------------+
//|  FUNÇÃO PARA MOVIMENTAR NO EIXO X A BARRA DE INFORMAÇÕES SELECIONADA COM O MOVIMENTO DO MOUSE |
//+-----------------------------------------------------------------------------------------------+
void CObjecto::Arrastar(int mousex, int mousey)
  {
   x7_= (int) ObjectGetInteger(0,objname7_,OBJPROP_XDISTANCE);
   if(ObjectGetInteger(0,objname7_,OBJPROP_BGCOLOR) == cor_clique)
     {
      if(x7_ < 0)
        {
         ObjectSetInteger(0,objname7_,OBJPROP_XDISTANCE,00);
        }
      if(x7_+x7_largura_ >= limite_)
        {
         Acoplados_add(objname7_);
        }
      if(x7_+x7_largura_ < limite_)
        {
         Acoplados_del(objname7_);
        }
      if(botao78_habilitado_para_arrastar)
        {
         if(x7_+x7_largura_ > 0)
           {
            int posi7=mousex-x7_;
            int posi8=mousex-x7_;
            ObjectSetInteger(0,objname7_,OBJPROP_XDISTANCE,mousex-10);
            ObjectSetInteger(0,objname8_,OBJPROP_XDISTANCE,mousex-10+2);
           }
        }
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| FUNÇÃO QUE VERIFICA AS COORDENADAS DA INTERFACE GRÁFICA.         |
//| DEVE SER EXECUTADA SEMPRE QUE O TAMAMHO DO GRÁFICO FOR ALTERADO  |
//+------------------------------------------------------------------+
void CInterface::VerificarCoordendas()
  {
   for(int i=0; i<ArraySize(lista_acoplados); i++)
     {
      int obj_largura=(int) ObjectGetInteger(0,lista_acoplados[i],OBJPROP_XSIZE);
      int limit=fgrafico-_larguraB1-_larguraB2-_larguraB3;
      string obj7=lista_acoplados[i];
      Ac_0_= StringSubstr(obj7,0,StringFind(obj7,"cbxx",0)-3);
      Ac_1_= StringSubstr(obj7,StringFind(obj7,"cbxx",0)-3,StringLen(obj7));
      Ac_2_=StringSubstr(Ac_1_,0,StringLen(Ac_1_)-1);
      string obj8=Ac_0_+Ac_2_+"8";
      ObjectSetInteger(0,obj7,OBJPROP_XDISTANCE,limit-obj_largura);
      ObjectSetInteger(0,obj8,OBJPROP_XDISTANCE,limit-obj_largura+2);
     }
   int fg=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   for(int i=0; i<ObjectsTotal(0,0,OBJ_RECTANGLE_LABEL); i++)
     {
      string ojn=ObjectName(0,i,0,OBJ_RECTANGLE_LABEL);
      if(StringFind(ojn,"cbxx7",0) > 0)
        {
         string ojnlabel=StringSubstr(ojn,0,StringLen(ojn)-1)+"8";
         int ox7=(int) ObjectGetInteger(0,ojn,OBJPROP_XDISTANCE);
         int oxl=(int) ObjectGetInteger(0,ojn,OBJPROP_XSIZE);
         int lit=fg-_larguraB1-_larguraB2-_larguraB3;
         if(ox7>=fg || ox7+oxl >= fg)
           {
            ObjectSetInteger(0,ojn,OBJPROP_XDISTANCE,lit-oxl);
            ObjectSetInteger(0,ojnlabel,OBJPROP_XDISTANCE,lit-oxl+2);
            Acoplados_add(ojn);
           }
        }
     }
   ChartRedraw();
  }
//+--------------------------------------------------------------------------------------------------------------------------------+
//| FUNÇÃO EXECUTADA QUANDO SE CLICA NO BOTÃO DE MINIMIZAR.                                                                        |
//| PODE SER USADA COMO REFERÊNCIA PARA OUTROS BOTÕES COMO PARA USAR DUPLO CLIQUE PARA ABRIR O PAINEL (FUNÇÃO TRAZERPARAFRENTE).   |
//+--------------------------------------------------------------------------------------------------------------------------------+
void CObjecto::CliqueDuplo()
  {
   Minimizar();
   clickTime = GetTickCount();
   if(clickTime < lastClickTime + DoubleClickDelayMillis)
     {
      if(!cliqueduplo)
        {
         cliqueduplo=1;
        }
      else
        {
         if(cliqueduplo_ticket == objname7_)
           {
            cliqueduplo_ticket=objname7_;
            Minimizar();
            Interface.VerificarCoordendas();
            // TrazerParaFrente(mover78Ticket,objname_tipo);
            cliqueduplo=0;
           }
         else
           {
            ObjectSetInteger(0,cliqueduplo_ticket,OBJPROP_BGCOLOR,cor_fundo);
            ObjectSetInteger(0,objname7_,OBJPROP_BGCOLOR,cor_fundo);
            Minimizar();
            // TrazerParaFrente(mover78Ticket,objname_tipo);
            cliqueduplo=1;
           }
        }
     }
   ChartRedraw();
   lastClickTime = clickTime;
  }
//+----------------------------------------------------------------------+
//| FUNÇÃO PARA ABRIR O PAINEL GRÁFICO QUANDO SE DÁ UM DUPLO CLIQUE.     |
//| ESTA FUNÇÃO AUMENTA A ALTURA DA BARRA DE INFORMAÇÕES DE ACORDO       |
//| COM O ALOR DA VARIAVEL _alturaB4_duploclique.                        |
//+----------------------------------------------------------------------+
void CObjecto::TrazerParaFrente()
  {
   int altura_ = ObjectGetInteger(0,objname7_,OBJPROP_YSIZE) == _alturaB4 ? _alturaB4_duploclique : _alturaB4;
   if(ObjectGetInteger(0,objname7_,OBJPROP_YSIZE) != _alturaB4_duploclique)
     {
      ObjectDelete(0,objname7_);
      ObjectDelete(0,objname8_);
      Rectangle(objname7_,x7_,y7_,x7_largura_,_alturaB4_duploclique);
      Label(objname8_,x8_,y8_,8,t8_);
      ObjectSetInteger(0,objname8_,OBJPROP_COLOR,t8_cor_);
      cliqueduplo=1;
     }
   else
     {
      ObjectSetInteger(0,objname7_,OBJPROP_YSIZE,_alturaB4);
      cliqueduplo=0;
     }
   ChartRedraw();
  }
//+-------------------------------------------------------------------------+
//| FUNÇÃO PARA ALTERAR O LABEL/TEXTO/STRING DA INTERFACE GRÁFICA           |
//+-------------------------------------------------------------------------+
void CObjecto::AlterarTexto(int chart_ID,string name8,string text,string name7)
  {
   ObjectSetString(chart_ID,name8,OBJPROP_TEXT,text);
////////////////////////////////////////////////////////////////
//  int len=(int) ObjectGetInteger(0,name8,OBJPROP_XSIZE);
//ObjectSetInteger(0,name7,OBJPROP_XSIZE,len+10);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| FUNÇÃO PARA CRIAR O OBJETO LABEL DA INTERFACE GRÁFICA.           |
//| SERVE PARA MOSTRAR O TEXTO DOS BOTÕES                            |
//+------------------------------------------------------------------+
bool Label(string nome, int xx, int yy, int fontsize, string texto)
  {
   const long              chart_ID=0;               // ID do gráfico
   const string            name=nome;                // nome da etiqueta
   const int               sub_window=0;             // índice da sub-janela
   const int               x=xx;                     // coordenada X
   const int               y=yy;                     // coordenada Y
   const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER; // canto do gráfico para ancoragem
   const string            text=texto;               // texto
   const string            font="Trebuchet MS";      // fonte
   const int               font_size=fontsize;       // tamanho da fonte
   const color             clr=cor_texto;             // cor
   const double            angle=0.0;                // inclinação do texto
   const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER; // tipo de ancoragem
   const bool              back=false;               // no fundo
   const bool              selection=false;          // destaque para mover
   const bool              hidden=true;              // ocultar na lista de objetos
   const long              z_order=1;                // prioridade para clicar no mouse
//  const string            tooltip="";
   ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
// ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
   ObjectSetString(chart_ID,name,OBJPROP_SYMBOL,_Symbol);
   ChartRedraw();
   return(true);
  }
//+------------------------------------------------------------------+
//|  FUNÇÃO PARA CRIAR O OBJETO DO TIPO RECTANGLE_LABEL (BOTÕES)     |
//+------------------------------------------------------------------+
void Rectangle(string objname,int xx,int yy,int ww,int hh)
  {
   const long                chart_ID=0;               // ID do gráfico
   const string              name=objname;             // nome da etiqueta
   const int                 sub_window=0;             // índice da sub-janela
   const int                 x=xx;                     // coordenada X
   const int                 y=yy;                     // coordenada Y
   const int                 width=ww;                 // largura
   const int                 height=hh;                // altura
   const color               back_clr=cor_fundo;       // cor do fundo
   const ENUM_BORDER_TYPE    border=0;                 // tipo de borda
   const ENUM_BASE_CORNER    corner=0;                 // canto do gráfico para ancoragem
   const color               clr=cor_borda;      // cor da borda plana (Flat)
//  const color               clr=clrDarkSeaGreen;      // cor da borda plana (Flat)
   const ENUM_LINE_STYLE     style=STYLE_SOLID;        // estilo da borda plana
   const int                 line_width=1;             // largura da borda plana
   const bool                back=false;               // no fundo
   const bool                selection=false;          // destaque para mover
   const bool                hidden=true;              // ocultar na lista de objeto
   const long                z_order=1;                // prioridade para clicar no mouse
   const string              tooltip=tooltip_;
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
      Print("Function ",__FUNCTION__," error ",GetLastError());
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip_);
   ObjectSetString(chart_ID,name,OBJPROP_SYMBOL,_Symbol);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|  FUNÇÃO PARA CRIAR O OBJETO DO TIPO HLINE                        |
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,        // ID de gráfico
                 const string          name="HLine",      // nome da linha
                 const int             sub_window=0,      // índice da sub-janela
                 double                price=0,           // line price
                 const color           clr=clrRed,        // cor da linha
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // estilo da linha
                 const int             width=1,           // largura da linha
                 const bool            back=false,        // no fundo
                 const bool            selection=false,   // destaque para mover
                 const bool            hidden=true,       //ocultar na lista de objetos
                 const long            z_order=0)         // prioridade para clique do mouse
  {
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price))
      Print("Function ",__FUNCTION__," error ",GetLastError());
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID,name,OBJPROP_SYMBOL,_Symbol);
   ChartRedraw();
   return(true);
  }
//+------------------------------------------------------------------+

