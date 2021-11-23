//+------------------------------------------------------------------+
//| Acoplamento.mqh                                                  |
//| Telegram: @grupomql5 & @comunidademql5 // http://t.me/grupomql5  |
//| Por Pedro                                                        |
//+------------------------------------------------------------------+
#property copyright  "Telegram: @grupomql5 || @comunidademql5 || por Pedro em 06.04.2021"
#property description "Virtualização das ordens pendentes e das posições/sl/tp - Em 17.03.2021"
#property version     "1.0"
#include <../Variables.mqh>;

//+--------------------------------------------------------------------------------+
//| FUNÇÃO EXECUTADA QUANDO SE APROXIMA DO LIMITE OU SE CLICA NO BOTÃO DE ACOPLAR  |
//+--------------------------------------------------------------------------------+
void acoplar()
  {
   ObjectSetInteger(0,objname7_,OBJPROP_BGCOLOR,cor_fundo);
   botao78_habilitado_para_arrastar=0;
   ObjectSetInteger(0,objname7_,OBJPROP_XDISTANCE,limite_-x7_largura_);
   ObjectSetInteger(0,objname8_,OBJPROP_XDISTANCE,limite_-x7_largura_+2);
   ObjectSetInteger(0,objname7_,OBJPROP_YSIZE,_alturaB4);
   Acoplados_add(objname7_);
  }
//+---------------- ----------------------------------------------------------------------+
//| FUNÇÃO PARA ADICIONAR DETERMINADO OBJETO GRÁFICO NA LISTA/ARRAY DE OBJETOS ACOPLADOS  |
//+---------------------------------------------------------------------------------------+
void Acoplados_add(string objname)
  {
   int check = Acoplados_Find(objname);
   if(check < 0)
     {
      ArrayResize(lista_acoplados,ArraySize(lista_acoplados)+1);
      lista_acoplados[ArraySize(lista_acoplados)-1]=objname;
     }
  }
//+---------------- ----------------------------------------------------------------------+
//| FUNÇÃO PARA REMOVER DETERMINADO OBJETO GRÁFICO NA LISTA/ARRAY DE OBJETOS ACOPLADOS  |
//+---------------------------------------------------------------------------------------+
void Acoplados_del(string objname)
  {
   int check = Acoplados_Find(objname);
   if(check >= 0)
     {
      for(int i=0; i<ArraySize(lista_acoplados); i++)
        {
         if(lista_acoplados[i]==objname)
           {
            ArrayRemove(lista_acoplados,i,1);
           }
        }
     }
  }
//+---------------- ------------------------------------------------------------------------+
//| FUNÇÃO PARA CHECAR SE DETERMINADO OBJETO GRÁFICO ESTÁ LISTA/ARRAY DE OBJETOS ACOPLADOS  |
//+-----------------------------------------------------------------------------------------+
int Acoplados_Find(string objname)
  {
   for(int i=0; i<ArraySize(lista_acoplados); i++)
     {
      if(lista_acoplados[i]==objname)
        {
         return(i);
         break;
        }
     }
   return(-1);
  }
//+---------------- ----------------------------------------------------------------------+
//| FUNÇÃO PARA ADICIONAR TODOS OS OBJETO GRÁFICO NA LISTA/ARRAY DE OBJETOS ACOPLADOS     |
//+---------------------------------------------------------------------------------------+
void Acoplados_total()
  {
   int fg=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   for(int i=0; i<ObjectsTotal(0,0,OBJ_RECTANGLE_LABEL); i++)
     {
      string ojn=ObjectName(0,i,0,OBJ_RECTANGLE_LABEL);
      if(StringFind(ojn,"cbxx7",0) > 0)
        {
         int ox7=(int) ObjectGetInteger(0,ojn,OBJPROP_XDISTANCE);
         int ox7l=(int) ObjectGetInteger(0,ojn,OBJPROP_XSIZE);
         int lit=fg-_larguraB1-_larguraB2-_larguraB3;
         if(ox7+ox7l+2 > lit-10)
           {
            Acoplados_add(ojn);
           }
        }
     }
  }
//+------------------------------------------------------------------+
