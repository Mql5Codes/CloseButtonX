//+------------------------------------------------------------------+
//| ClasseMasterCloseButtonX.mqh                                     |
//| Telegram: @grupomql5 & @comunidademql5 // http://t.me/grupomql5  |
//| Por Pedro                                                        |
//+------------------------------------------------------------------+
#property copyright  "Telegram: @grupomql5 || @comunidademql5 || por Pedro em 06.04.2021"
#property version     "1.0"
#include "Variables.mqh";
#include "OnEvent.mqh";
//+------------------------------------------------------------------+
//|  Módulo Principal: Classe CMasterCloseButtonX                    |
//+------------------------------------------------------------------+
class CMasterCloseButtonX:public CEventos
  {
protected:
   bool              on_event;

public:
                     CMasterCloseButtonX();
                    ~CMasterCloseButtonX();

   void              Run();
   void              Deinit();
  };
//+------------------------------------------------------------------+
//| CMasterCloseButtonX :: CONSTRUTOR DA CLASSE                      |
//+------------------------------------------------------------------+
CMasterCloseButtonX::CMasterCloseButtonX()
  {
   on_event=false;
  }
//+------------------------------------------------------------------+
//| ClasseMasterCloseButtonX  :: DESTRUTOR DA CLASSE                 |
//+------------------------------------------------------------------+
CMasterCloseButtonX::~CMasterCloseButtonX()
  {
   Comment("");
   ObjectsDeleteAll(0,0,-1);
  }
//+---------------------------------------------------------------------+
//| Método de inicialização do módulo principal (algoritmo principal)   |
//+---------------------------------------------------------------------+
void CMasterCloseButtonX::Run()
  {
   ObjectsDeleteAll(0,0,-1);
   //Comment("Inicializando CloseButtonX v.2.50");
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,1);
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_CREATE,true);
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_DELETE,false);
   on_event=true;
   DecimalShift();
   Interface.Atualizar();
  }

//+------------------------------------------------------------------+
//| Calcular Multiplo para corrigir o decimal dos pontos ou pips     |
//+------------------------------------------------------------------+
void DecimalShift()
  {
   int total=_Digits;
   for(int i=0; i<total; i++)
      decimal+="0";
   }
//+------------------------------------------------------------------+
//| Método de desinicialização                                       |
//+------------------------------------------------------------------+
void CMasterCloseButtonX::Deinit()
  {
   ObjectsDeleteAll(0,0,-1);
  }
//+------------------------------------------------------------------+
