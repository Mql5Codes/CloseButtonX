//+------------------------------------------------------------------+
//| OnEvent.mqh                                                      |
//| Telegram: @grupomql5 & @comunidademql5 // http://t.me/grupomql5  |
//| Por Pedro                                                        |
//+------------------------------------------------------------------+
#property copyright  "Telegram: @grupomql5 || @comunidademql5 || por Pedro em 06.04.2021"
#property description "Monitora eventos no gráfico - Em 17.03.2021"
#property version     "1.0"
#include <../Virtualization.mqh>;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CEventos
  {
protected:
                     CEventos(void) { };
                    ~CEventos(void) { };
public:

   void              OnTick(void);
   void              OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
   void              OnTradeTransaction(const MqlTradeTransaction& trans,
                                        const MqlTradeRequest& request,
                                        const MqlTradeResult& result);

  };
//+------------------------------------------------------------------+
//| Método de processamento de evento OnTick()                       |
//+------------------------------------------------------------------+
void CEventos::OnTick()
  {
   Info.Update_Ordens();
   Info.Update_Posicoes();
   Interface.VirtualOnTick();
//Virtual.Listar();
  }
//+------------------------------------------------------------------+
//| FUNÇÃO CHAMADA QUANDO OCORRE ALGUM EVENTO NO GRÁFICO             |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Método de processamento de eventos OnChartEvent()                |
//+------------------------------------------------------------------+
void CEventos::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   int      x     =(int)lparam;
   int      y     =(int)dparam;
   if(sparam == "1" && botao78_habilitado_para_arrastar)
     {
        {
         Interface.Deselecionar();
        }
     }
   switch(id)
     {
      case CHARTEVENT_CHART_CHANGE:
        {
         chartcount++;
         //Painel();
         int checkGraficoW=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
         Interface.Atualizar();
         if(checkGraficoW_ != checkGraficoW)
           {
            Interface.VerificarCoordendas();
            checkGraficoW_=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
            botao78_habilitado_para_arrastar=0;
           }
        }
      case CHARTEVENT_OBJECT_CLICK:
        {
         //+------------------------------------------------------------------+
         //| DETECTAR QUANDO SE CLICAR NA HLINE DA ORDEM/POSIÇÃO VIRTUAL      |
         //+------------------------------------------------------------------+
         if(StringFind(sparam,"cbxx",0) > 0 && ObjectGetInteger(0,sparam,OBJPROP_TYPE) == OBJ_HLINE)
           {
            if(!hline_mover) //ativar movimento
              {
               hline_select=sparam;
               hline_mover=1;
              }
            else //desativar movimento
              {
               hline_mover=0;
               double hline_price= ObjectGetDouble(0,hline_select,OBJPROP_PRICE);
               Virtual.Modify(hline_select,hline_price);

              }
           }
         //+------------------------------------------------------------------+
         //| BOTÃO QUE VIRTUALIZA POSIÇÃO/ORDEM                               |
         //+------------------------------------------------------------------+
         if((StringFind(sparam,"cbxx5",0) > 0 || StringFind(sparam,"cbxx6",0) > 0) && StringFind(sparam,"PCLcbxx",0) < 0)
           {
            Virtual.VirtualClique(sparam);
           }
         //+------------------------------------------------------------------+
         //| BOTÃO QUE DESVIRTUALIZA POSIÇÃO/ORDEM                            |
         //+------------------------------------------------------------------+
         if(StringFind(sparam,"Vcbxx1",0) > 0 || StringFind(sparam,"Vcbxx2",0) > 0)
           {
            Virtual.Del(StringSubstr(sparam,0,StringLen(sparam)-1),0);
           }
         //+------------------------------------------------------------------+
         //| BOTÃO DE FECHAMENTO DE ORDEM PENDENTE                            |
         //+------------------------------------------------------------------+
         if(StringFind(sparam,"OCLcbxx1",0) > 0 || StringFind(sparam,"OCLcbxx2",0) > 0)
           {
            int ticketSelecionado=(int)StringSubstr(sparam,0,StringFind(sparam,"OCLcbxx",0));
            Trade.OrderDelete(ticketSelecionado);
            string slname=StringSubstr(sparam,0,StringLen(sparam)-7)+"SLVcbxx";
            string tpname=StringSubstr(sparam,0,StringLen(sparam)-7)+"TPVcbxx";
            Virtual.Del(slname,0);
            Virtual.Del(tpname,0);
           }
         //+------------------------------------------------------------------+
         //| BOTÃO DE FECHAMENTO DE POSIÇÃO                                   |
         //+------------------------------------------------------------------+
         if(StringFind(sparam,"PCLcbxx1",0) > 0 || StringFind(sparam,"PCLcbxx2",0) > 0)
           {
            int ticketSelecionado=(int)StringSubstr(sparam,0,StringFind(sparam,"PCLcxx",0)-1);
            Trade.PositionClose((ulong) ticketSelecionado);
            string slname=StringSubstr(sparam,0,StringLen(sparam)-7)+"SLVcbxx";
            string tpname=StringSubstr(sparam,0,StringLen(sparam)-7)+"TPVcbxx";
            Virtual.Del(slname,0);
            Virtual.Del(tpname,0);
            //     Interface.Atualizar();
           }
         //+------------------------------------------------------------------+
         //| BOTÃO DE FECHAMENTO DE STOPLOSS                                  |
         //+------------------------------------------------------------------+
         if(StringFind(sparam,"SLcbxx1",0) > 0 || StringFind(sparam,"SLcbxx2",0) > 0)
           {
            int ticketSelecionado=(int)StringSubstr(sparam,0,StringFind(sparam,"PSLcbxx",0));
            PositionSelectByTicket(ticketSelecionado);
            double tp=PositionGetDouble(POSITION_TP);
            Trade.PositionModify((ulong) ticketSelecionado,0,tp);
           }
         //+------------------------------------------------------------------+
         //| BOTÃO DE FECHAMENTO DE TAKEPROFIT                                |
         //+------------------------------------------------------------------+
         if(StringFind(sparam,"PTPcbxx1",0) > 0 || StringFind(sparam,"PTPcbxx2",0) > 0)
           {
            int ticketSelecionado=(int)StringSubstr(sparam,0,StringFind(sparam,"PTPcbxx",0));
            PositionSelectByTicket(ticketSelecionado);
            double sl=PositionGetDouble(POSITION_SL);
            Trade.PositionModify((ulong) ticketSelecionado,sl,0);
           }
         //+------------------------------------------------------------------+
         //| BOTÃO QUE MINIMIZA/MAXIMIZA                                      |
         //+------------------------------------------------------------------+
         if(StringFind(sparam,"cbxx3",0) > 0 || StringFind(sparam,"cbxx4",0) > 0)
           {
            Interface.Selecionar(sparam);
            Interface.CliqueDuplo();
            Interface.VerificarCoordendas();
            //acoplar();
            //TrazerParaFrente();
           }
         //+-----------------------------------------------------------------+
         //| BOTÃO DA BARRA DE INFORMAÇÕES                                   |
         //+-----------------------------------------------------------------+
         if(StringFind(sparam,"cbxx7",0) > 0 || StringFind(sparam,"cbxx8",0) > 0)
           {
            Interface.Selecionar(sparam);
            if(StringFind(sparam,"OCL") >= 0)
              {
               cor_fundo=ord_cor_fundo;
               cor_clique=ord_cor_clique;
               cor_borda=ord_cor_borda;
               cor_texto=ord_cor_texto;
              }
            if(StringFind(sparam,"OSL") >= 0)
              {
               cor_fundo=ord_sl_cor_fundo;
               cor_clique=ord_sl_cor_clique;
               cor_borda=ord_sl_cor_borda;
               cor_texto=ord_sl_cor_texto;
              }
            if(StringFind(sparam,"OTP") >= 0)
              {
               cor_fundo=ord_tp_cor_fundo;
               cor_clique=ord_tp_cor_clique;
               cor_borda=ord_tp_cor_borda;
               cor_texto=ord_tp_cor_texto;
              }
            if(StringFind(sparam,"PCL") >= 0)
              {
               cor_fundo=pos_cor_fundo;
               cor_clique=pos_cor_clique;
               cor_borda=pos_cor_borda;
               cor_texto=pos_cor_texto;
              }
            if(StringFind(sparam,"PSL") >= 0)
              {
               cor_fundo=pos_sl_cor_fundo;
               cor_clique=pos_sl_cor_clique;
               cor_borda=pos_sl_cor_borda;
               cor_texto=pos_sl_cor_texto;
              }
            if(StringFind(sparam,"PTP") >= 0)
              {
               cor_fundo=pos_tp_cor_fundo;
               cor_clique=pos_tp_cor_clique;
               cor_borda=pos_tp_cor_borda;
               cor_texto=pos_tp_cor_texto;
              }
            color AlterarCorBotao=ObjectGetInteger(0,objname7_,OBJPROP_BGCOLOR) == cor_fundo ? cor_clique : cor_fundo;
            if(AlterarCorBotao != cor_fundo)
              {
               ObjectSetInteger(0,objname7_,OBJPROP_BGCOLOR,AlterarCorBotao);
               objecto_selecionado_para_arrastar=sparam;
               botao78_habilitado_para_arrastar=1;
              }
            else
              {
               ObjectSetInteger(0,objname7_,OBJPROP_BGCOLOR,AlterarCorBotao);
               botao78_habilitado_para_arrastar=0;
              }
           }
        }
      //+------------------------------------------------------------------+
      //| EVENTO DO MOUSE                                                  |
      //+------------------------------------------------------------------+
      case CHARTEVENT_MOUSE_MOVE:
        {
         //+------------------------------------------------------------------+
         //| ATUALIZAR A HLINE DO BOTÃO VIRTUAL                               |
         //+------------------------------------------------------------------+
         if(hline_mover)
           {
            datetime hline_time;
            double hline_price;
            int subwindow=0;
            string text_="carregando dados... CHARTEVENT_MOUSE_MOVE";
            if(ArraySize(virtual_lista) > 0 && !StringFind(sparam,"cbxx",0))
              {
               //  text_=(string) virtual_lista[Virtual.Find(hline_select)].order_type0+" | "+(string) virtual_lista[Virtual.Find(hline_select)].order_price+" | "+(string) virtual_lista[Virtual.Find(hline_select)].order_volume;
              }
            ChartXYToTimePrice(0,(int)lparam,(int)dparam,subwindow,hline_time,hline_price);
            int index=Virtual.Find(hline_select);
            if(index >= 0)
              {
               Virtual.Modify(hline_select,hline_price);
               Info.Update();
              }
           }
         if(botao78_habilitado_para_arrastar)
           {
            Interface.Arrastar(x,y);
            objecto_selecionado_para_arrastar_=objecto_selecionado_para_arrastar;
            if(objecto_selecionado_para_arrastar_==objecto_selecionado_para_arrastar)
              {
               Interface.Arrastar(x,y);
               objecto_selecionado_para_arrastar_=objecto_selecionado_para_arrastar;
              }
            else
              {
               Interface.Selecionar(objecto_selecionado_para_arrastar);
               Interface.Arrastar(x,y);
               objecto_selecionado_para_arrastar_=objecto_selecionado_para_arrastar;
              }
           }
        }
     }
  }

//+--------------------------------------------------------------------------+
//| Método de processamento de evento OnTradeTransaction()                   |
//+--------------------------------------------------------------------------+
//+--------------------------------------------------------------------------+
//| FUNÇÃO CHAMADA QUANDO OCORRE ALGUMA TRANSAÇÃO ENTRE TERMINAL E SERVIDOR  |
//+--------------------------------------------------------------------------+
void CEventos::OnTradeTransaction(
   const MqlTradeTransaction&    trans,        // estrutura de transação da negociação
   const MqlTradeRequest&        request,      // estrutura de solicitação
   const MqlTradeResult&         result        // estrutura de respost)
)
  {
   if(!trans.type && trans.order) //MOSTRAR BOTOES LOGO NO PRIMEIRO MOMENTO
     {
      //      Print(__FUNCTION__," : ",__LINE__);
      Interface.Atualizar();
     }
   ENUM_TRADE_TRANSACTION_TYPE type=trans.type;
   if(type == TRADE_TRANSACTION_DEAL_UPDATE)
     {
     }
   if(type == TRADE_TRANSACTION_HISTORY_ADD)
     {
      //+------------------------------------------------------------------+
      //| Detecta O Cancelamento de Ordem Pendente                         |
      //+------------------------------------------------------------------+
      if(trans.order_state==2)
        {
         Interface.Apagar((string) trans.order+"OCLcbxx",0);
        }
     }
   if(type==TRADE_TRANSACTION_DEAL_ADD)
     {
      long     deal_entry        =0;
      string   deal_symbol       ="";
      long     deal_magic        =0;
      long     deal_reason       =0;
      int      order_state       =0;
      if(HistoryDealSelect(trans.deal) && !trans.order_state)
        {
         Interface.Atualizar();
         //     ChartRedraw();
         //+------------------------------------------------------------------+
         //| Apagar os botoes da ordem a mercado que se transformou posição   |
         //+------------------------------------------------------------------+
         Interface.Apagar((string) trans.order+"OCLcbxx",0); //-- Apagar os botoes da ordem a mercado que se transformou posição
         order_state = (int) HistoryOrderGetInteger(trans.deal,ORDER_STATE);
         if(order_state == ORDER_STATE_CANCELED)
           {
           }
         if(order_state == ORDER_STATE_REQUEST_MODIFY)
           {
           }
         deal_symbol=HistoryDealGetString(trans.deal,DEAL_SYMBOL);
         deal_magic=HistoryDealGetInteger(trans.deal,DEAL_MAGIC);
         deal_entry=HistoryDealGetInteger(trans.deal,DEAL_ENTRY);
         if(deal_symbol==Symbol() && (ENUM_DEAL_ENTRY)deal_entry==DEAL_ENTRY_OUT) // if(deal_symbol==Symbol() && deal_magic==MagicNumber && (ENUM_DEAL_ENTRY)deal_entry==DEAL_ENTRY_OUT)
           {
            deal_reason=HistoryDealGetInteger(trans.deal,DEAL_REASON);
            //+------------------------------------------------------------------+
            //| DETECTA O FECHAMENTO DE POSIÇÃO                                  |
            //+------------------------------------------------------------------+
            if(deal_reason != DEAL_REASON_SL && deal_reason !=DEAL_REASON_TP)
              {
               //Print("DETECTA O FECHAMENTO DE POSIÇÃO  : ",trans.position);
               Interface.Apagar((string) trans.position+"PCLcbxx",0);
               Interface.Apagar((string) trans.position+"PSLcbxx",0);
               Interface.Apagar((string) trans.position+"PTPcbxx",0);
              }
            //+------------------------------------------------------------------+
            //| DETECTA POSIÇÃO FECHADA POR STOPLOSS                             |
            //+------------------------------------------------------------------+
            if(deal_reason==DEAL_REASON_SL)
              {
               Interface.Apagar((string) trans.position+"PCLcbxx",0);
               Interface.Apagar((string) trans.position+"PSLcbxx",0);
               Interface.Apagar((string) trans.position+"PTPcbxx",0);
               //ApagarBotao((string) trans.order+"OCLcbxx",0) //ticket da ordem que fechou a posição original
              }
            //+------------------------------------------------------------------+
            //| DETECTA POSIÇÃO FECHADA POR TAKEPROFIT                           |
            //+------------------------------------------------------------------+
            if(deal_reason==DEAL_REASON_TP)
              {
               Interface.Apagar((string) trans.position+"PCLcbxx",0);
               Interface.Apagar((string) trans.position+"PSLcbxx",0);
               Interface.Apagar((string) trans.position+"PTPcbxx",0);
             //  ApagarBotao((string) trans.order+"OCLcbxx",0); //ticket da ordem que fechou a posição original
              }
           }
        }
     }
//+--------------------------------------------------------------------------+
//| MONITORA MODIFICAÇÃO OU CANCELAMENTO DE ORDEM STOPLOSS OU TAKEPROFIT     |
//+--------------------------------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_POSITION)
     {
      if(trans.price_sl)
        {
         int index= Virtual.Find((string) trans.position+"PTPVcbxx");
         if(index>=0)
           {
           // virtual_lista[index].order_sl=trans.price_sl;
           }
        }
      if(trans.price_tp)
        {
         int index= Virtual.Find((string) trans.position+"PSLVcbxx");
         if(index>=0)
           {
        //    virtual_lista[index].order_tp=trans.price_tp;
           }
        }
      //+------------------------------------------------------------------+
      //|  DETECTA A REMOÇÃO DO STOPLOSS PELO USUÁRIO                      |
      //+------------------------------------------------------------------+
      if(!trans.price_sl && trans.price_tp)
        {
         string slname=(string)trans.position+"PSLVcbxx";
         if(Virtual.Find(slname) >= 0) /////////////////////
           {
            // Print(__FUNCTION__," : ",__LINE__);
            // Virtual_del(slname,0);
           }
         Interface.Apagar((string) trans.position+"PSLcbxx",0);
        }

      //+------------------------------------------------------------------+
      //|  DETECTA A REMOÇÃO DO TAKEPROFIT PELO USUÁRIO                    |
      //+------------------------------------------------------------------+
      if(!trans.price_tp && trans.price_sl)
        {
         string tpname=(string) trans.position+"PTPVcbxx";
         if(Virtual.Find(tpname) >= 0) /////////////////
           {
            // Print(__FUNCTION__," : ",__LINE__);
            // Virtual_del(tpname,0);
           }
         Interface.Apagar((string) trans.position+"PTPcbxx",0);
        }
      //+------------------------------------------------------------------+
      //| DETECTA A REMOÇÃO DO STOPLOSS && TAKEPROFIT PELO USUÁRIO         |
      //+------------------------------------------------------------------+
      if(!trans.price_sl && !trans.price_tp)
        {
         Interface.Apagar((string) trans.position+"PSLcbxx",0);
         Interface.Apagar((string) trans.position+"PTPcbxx",0);
        }
      Interface.Atualizar();
      //    ChartRedraw();
     }
//+------------------------------------------------+
//| MONITORA MODIFICAÇÃO EM ORDEM PENDENTE         |
//+------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_UPDATE && trans.type)
     {
      Interface.Atualizar();
     }
//+------------------------------------------------------------------+
//| MONITORA A ADIÇÃO DE UMA ORDEM DETECTADA PELO: trans.type == 0   |
//+------------------------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_ADD) //monitorar adição de ordem trans.type == 0
     {
      Interface.Atualizar();
     }
//+------------------------------------------------------------------+
//| QUANDO UMA ORDEM PENDENTE É CANCELADA PELO USUÁRIO               |
//+------------------------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_DELETE && trans.order_state == ORDER_STATE_CANCELED)
     {
      Interface.Apagar((string) trans.order+"OCLcbxx",0);
      Interface.Atualizar();
     }
//+------------------------------------------------------------------+
//| MONITORA A ADIÇÃO DE UMA ORDEM DETECTADA PELO: trans.type == 3   |
//+------------------------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_DELETE)
     {
      Interface.Atualizar();
     }
   if(result.order)
     {
      //   Interface.Atualizar();
      //   ChartRedraw();
     }
  }
//+------------------------------------------------------------------+

