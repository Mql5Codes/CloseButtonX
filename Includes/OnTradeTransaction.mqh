//+------------------------------------------------------------------+
//|                                           OnTradeTransaction.mqh |
//|                                                 Brazil Maio 2020 |
//|                                                www.script.com.br |
//+------------------------------------------------------------------+
#property copyright "Brazil Maio 2020"
#property description "Monitora Transações - Em 17.03.2021"
#property description "Versão 1.00 - Em 17.03.2021"
#property link      "www.script.com.br"
#include <../Interface.mqh>;
//+--------------------------------------------------------------------------+
//| FUNÇÃO CHAMADA QUANDO OCORRE ALGUMA TRANSAÇÃO ENTRE TERMINAL E SERVIDOR  |
//+--------------------------------------------------------------------------+
void XOnTradeTransaction(
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
         Interface.Apagar((string) trans.order+"OCLcbxx", 0);
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
         ChartRedraw();
         Interface.Apagar((string) trans.order+"OCLcbxx", 0); //////Apagar os botoes da ordem a mercado que se transformou posição
         order_state = (int) HistoryOrderGetInteger(trans.deal, ORDER_STATE);
         if(order_state == ORDER_STATE_CANCELED)
           {
           }
         if(order_state == ORDER_STATE_REQUEST_MODIFY)
           {
           }
         deal_symbol=HistoryDealGetString(trans.deal, DEAL_SYMBOL);
         deal_magic=HistoryDealGetInteger(trans.deal, DEAL_MAGIC);
         deal_entry=HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
         if(deal_symbol==Symbol() && (ENUM_DEAL_ENTRY)deal_entry==DEAL_ENTRY_OUT) // if(deal_symbol==Symbol() && deal_magic==MagicNumber && (ENUM_DEAL_ENTRY)deal_entry==DEAL_ENTRY_OUT)
           {
            deal_reason=HistoryDealGetInteger(trans.deal, DEAL_REASON);
            //+------------------------------------------------------------------+
            //| DETECTA O FECHAMENTO DE POSIÇÃO                                  |
            //+------------------------------------------------------------------+
            if(deal_reason != DEAL_REASON_SL && deal_reason !=DEAL_REASON_TP)
              {
               Interface.Apagar((string) trans.position+"PCLcbxx", 0);
               Interface.Apagar((string) trans.position+"PSLcbxx", 0);
               Interface.Apagar((string) trans.position+"PTPcbxx", 0);
              }
            //+------------------------------------------------------------------+
            //| DETECTA POSIÇÃO FECHADA POR STOPLOSS                             |
            //+------------------------------------------------------------------+
            if(deal_reason==DEAL_REASON_SL)
              {
               Interface.Apagar((string) trans.position+"PCLcbxx", 0);
               // ApagarBotao((string) trans.order+"OCLcbxx",0) //ticket da ordem que fechou a posição original
               ChartRedraw();
              }
            //+------------------------------------------------------------------+
            //| DETECTA POSIÇÃO FECHADA POR TAKEPROFIT                           |
            //+------------------------------------------------------------------+
            if(deal_reason==DEAL_REASON_TP)
              {
               Interface.Apagar((string) trans.position+"PCLcbxx", 0);
               //    ApagarBotao((string) trans.order+"OCLcbxx",0); //ticket da ordem que fechou a posição original
               ChartRedraw();
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
        }
      if(trans.price_tp)
        {
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
         Interface.Apagar((string) trans.position+"PSLcbxx", 0);
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
         Interface.Apagar((string) trans.position+"PTPcbxx", 0);
        }
      //+------------------------------------------------------------------+
      //| DETECTA A REMOÇÃO DO STOPLOSS && TAKEPROFIT                      |
      //+------------------------------------------------------------------+
      if(!trans.price_sl && !trans.price_tp)
        {
         Interface.Apagar((string) trans.position+"PSLcbxx", 0);
         Interface.Apagar((string) trans.position+"PTPcbxx", 0);
        }
      Interface.Atualizar();
      ChartRedraw();
     }
//+------------------------------------------------+
//| MONITORA MODIFICAÇÃO EM ORDEM PENDENTE         |
//+------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_UPDATE && trans.type)
     {
     }
//+------------------------------------------------------------------+
//| MONITORA A ADIÇÃO DE UMA ORDEM DETECTADA PELO: trans.type == 0   |
//+------------------------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_ADD) //monitorar adição de ordem trans.type == 0
     {
     }
//+------------------------------------------------------------------+
//| QUANDO UMA ORDEM PENDENTE É CANCELADA PELO USUÁRIO               |
//+------------------------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_DELETE && trans.order_state == ORDER_STATE_CANCELED)
     {
      Interface.Apagar((string) trans.order+"OCLcbxx", 0);
     }
//+------------------------------------------------------------------+
//| MONITORA A ADIÇÃO DE UMA ORDEM DETECTADA PELO: trans.type == 3   |
//+------------------------------------------------------------------+
   if(trans.type == TRADE_TRANSACTION_ORDER_DELETE)
     {
     }
   if(result.order)
     {
      Interface.Atualizar();
      ChartRedraw();
     }
  }
//+------------------------------------------------------------------+
