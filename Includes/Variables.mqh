//+------------------------------------------------------------------+
//| Variaveis.mqh                                                    |
//| Telegram: @grupomql5 & @comunidademql5 // http://t.me/grupomql5  |
//| Por Pedro                                                        |
//+------------------------------------------------------------------+
#property copyright  "Telegram: @grupomql5 || @comunidademql5 || por Pedro em 06.04.2021"
#property description "Varivaveis - Em 17.03.2021"
#property version     "1.0"


//+------------------------------------------------------------------+


input int            largura_2_barra_=260;            //Largura da barra maior
input int            largura_1_barra_=150;            //Largura da barra menor
input bool           margem_estado_=0;                //Ativar Margem de Segurança
input double         margem_de_seguranca_=0;          //Margem de proteção abaixo do stop virtual

input group          "Cores das Ordens"
input color          ord_cor_fundo_=clrLightGoldenrod;   // Cor do Fundo
input color          ord_cor_borda_=clrDarkSeaGreen;     // Cor da Borda
input color          ord_cor_texto_=clrBlack;            // Cor do texto
//input color          ord_cor_clique_=clrGreenYellow;     // Cor quando selecionado
input color          ord_cor_linha_virtual_=clrBrown;    // Cor da linha da ordem virtual
input string         ord_texto_grande_="< :num | :tipo | :open | :vol ";  //Informações na barra maior
input string         ord_texto_mini_="< :tipo | :open";                  //Informações na barra menor


input group          "Config das Posições"
input color          pos_cor_fundo_=clrLightGoldenrod;   // Cor do Fundo
input color          pos_cor_borda_=clrDarkSeaGreen;     // Cor da Borda
input color          pos_cor_texto_=clrBlack;            // Cor do texto
//input color          pos_cor_clique_=clrGreenYellow;     // Cor quando selecionado
input string         pos_texto_grande_="< :num | :tipo | :lucro | :open | :vol";  //Informações na barra maior
input string         pos_texto_mini_="< :tipo | :open | :lucro";                         //Informações na barra menor

input group          "Config Stoploss"
input color          pos_sl_cor_fundo_=clrLightGoldenrod;   // Cor do Fundo
input color          pos_sl_cor_borda_=clrDarkSeaGreen;     // Cor da Borda
input color          pos_sl_cor_texto_=clrRed;              // Cor do texto
//input color          pos_sl_cor_clique_=clrGreenYellow;     // Cor quando selecionado
input string         pos_sl_texto_grande_="< :num | SL | :lucro | :open | :pontos | :rr";  //Informações na barra maior
input string         pos_sl_texto_mini_="< SL | :open | :lucro";                                 //Informações na barra menor


input group          "Config Takeprofit"
input color          pos_tp_cor_fundo_=clrLightGoldenrod;       // Cor do Fundo
input color          pos_tp_cor_borda_=clrDarkSeaGreen;         // Cor da Borda
input color          pos_tp_cor_texto_=clrGreen;                // Cor do texto
//input color          pos_tp_cor_clique_=clrGreenYellow;         // Cor quando selecionado
input color          pos_cor_linha_virtual_=clrDarkOliveGreen;  // Cor da linha do takeprofit virtual
input string         pos_tp_texto_grande_="< :num | TP | :lucro | :open | :pontos | :rr";  //Informações na barra maior
input string         pos_tp_texto_mini_="< TP | :open | :lucro";                         //Informações na barra menor

//string textobotao1pos="< :rr | :num | :tipo | :open | :vol | :lucro | :ticket"; //texto posição aberta
//string textobotao1ord="< :num | :tipo | :open | :vol | :ticket"; //texto ordem pendente
//string textobotao2="< :pontos | :lucro | :porc | :rr"; //Texto stoploss
//string textobotao3="< :pontos | :lucro | :porc | :rr"; //Texto takeprofit
////string textobotao2="< :num | SL | :tipo | :open | :lucro | :ticket";
////string textobotao3="< :num | TP | :tipo | :open | :lucro | :ticket";
//string minitexto_pos="< :tipo | :open | :lucro";
//string minitexto_ord="< :tipo | :open";
//string minitexto_sl="< STOPLOSS | :open";
//string minitexto_tp="< TAKEPROFIT | :open";
string tooltip_;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool margem_estado=margem_estado_ > 0 ? margem_estado_-(margem_estado_*2) : margem_estado_;
double margem_de_seguranca=margem_de_seguranca_;
color pos_cor_linha_virtual=pos_cor_linha_virtual_;
int largura_2_barra=largura_1_barra_;
int largura_1_barra=largura_2_barra_;

int _larguraB4=largura_1_barra_;

string ord_texto_grande=ord_texto_grande_;
string ord_texto_mini=ord_texto_mini_;
string pos_texto_grande=pos_texto_grande_;
string pos_texto_mini=pos_texto_mini_;
string pos_sl_texto_grande=pos_sl_texto_grande_;
string pos_sl_texto_mini=pos_sl_texto_mini_;
string pos_tp_texto_grande=pos_tp_texto_grande_;
string pos_tp_texto_mini=pos_tp_texto_mini_;

color ord_cor_fundo = ord_cor_fundo_;       // Cor do Fundo
color ord_cor_borda = ord_cor_borda_;       // Cor da Borda
color ord_cor_texto = ord_cor_texto_;       // Cor do texto
color ord_cor_clique= clrGreenYellow;      // Cor quando selecionado
color pos_cor_fundo= pos_cor_fundo_;       // Cor do Fundo
color pos_cor_borda= pos_cor_borda_;       // Cor da Borda
color pos_cor_texto= pos_cor_texto_;       // Cor do texto
color pos_cor_clique= clrGreenYellow;     // Cor quando selecionado
color pos_sl_cor_fundo= pos_sl_cor_fundo_;         // Cor do Fundo
color pos_sl_cor_borda= pos_sl_cor_borda_;         // Cor da Borda
color pos_sl_cor_texto= pos_sl_cor_texto_;         // Cor do texto
color pos_sl_cor_clique= clrGreenYellow;       // Cor quando selecionado
color pos_tp_cor_fundo=pos_tp_cor_fundo_;          // Cor do Fundo
color pos_tp_cor_borda=pos_tp_cor_borda_;          // Cor da Borda
color pos_tp_cor_texto=pos_tp_cor_texto_;          // Cor do texto
color pos_tp_cor_clique=clrGreenYellow;         // Cor quando selecionado
color ord_sl_cor_fundo=ord_cor_fundo_;
color ord_sl_cor_clique=clrGreenYellow;
color ord_sl_cor_borda=ord_cor_borda_;
color ord_sl_cor_texto=ord_cor_texto_;
color ord_tp_cor_fundo=ord_cor_fundo_;
color ord_tp_cor_clique=clrGreenYellow;
color ord_tp_cor_borda=ord_cor_borda_;
color ord_tp_cor_texto=ord_cor_texto_;
//+------------------------------------------------------------------+

bool debug =1;
const int DoubleClickDelayMillis = 500;
ulong lastClickTime;
ulong clickTime;
bool cliqueduplo=0;
string decimal="1";
string objnamebotao1;
string objnamebotao2;
string objnamebotao3;
string objnamebotao4;
string objnamebotao5;
string objnamebotao6;
string objnamebotao7;
string objnamebotao8;
double PriceOpenAntigo;
double PriceStopAntigo;
double PriceTPAntigo;
double PriceOpenAntigoOrder;
double PriceStopAntigoOrder;
double PriceTPAntigoOrder;
int xantigo;
int yantigo;
int a;
int b;
int fgrafico;
int fgraficoAntigo=0;
/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////

color corLinhaNegocio = clrGreen;
color corLinhaStopLoss = clrRed;
color corLinhaTakeProfit = clrMediumBlue;
bool mover78=0;
bool botao78_habilitado_para_arrastar;
color cor_fundo;
color cor_borda;
color cor_texto;
color cor_clique;
//color cor_fundo1=clrLightGoldenrod;
//color cor_fundoc1=clrGreenYellow;
//color cor_open1=clrBlack;
//color cor_sl1=clrRed;
//color cor_tp1=clrGreen;
//color cor_fundo=cor_fundo1;
//color cor_fundoc=cor_fundoc1;
//color cor_open=cor_open1;
//color cor_SL=cor_sl1;
//color cor_TP=cor_tp1;
//////////////////////////////////////////////////////////////////
//-- Dimensões dos botões
int _larguraB1=15;
int _alturaB1=12;
int _larguraB2=15;
int _alturaB2=12;
int _larguraB3=15;
int _alturaB3=12;

int _alturaB4=12;
int _alturaB4_duploclique= 90; //Variavel da função TrazerParaFrente();
//int tamanhomini_= 150; //150; //padrão 130
////////////////// x
int _xB1=_larguraB1;
int _xL1=_xB1+3;
int _xB2=_xB1+_larguraB2;
int _xL2=_xB2+4;
int _xB3=_xB2+_larguraB3;
int _xL3=_xB3+2;
int _xB4=_xB3+_larguraB4;
int _xL4=_xB4+5;
//////////////////// y
int _yB1=13;
int _yL1=_yB1+6;
int _yB2=13;
int _yL2=_yB2+6;
int _yB3=13;
int _yL3=_yB3+2;
int _yB4=13;
int _yL4=_yB4+2;
int tamanhoGrafico_;
int minitextoOrdON;
int minitextoPosON;
int minitextoSLON;
int minitextoTPON;
string Ac_0_;
string Ac_1_;
string Ac_2_;
string objname3_;
string objname4_;
string objname5_;
string objname7_;
string objname8_;
int limite_;
int x7_largura_;
int x7_;
int x8_;
int y7_;
int y8_;
string t8_;
color t8_cor_;

int recuo_=x7_+(_larguraB4-largura_1_barra_);

string objecto_selecionado_para_arrastar;
int checkGraficoW_;
string objecto_selecionado_para_arrastar_;
string lista_acoplados[];
string cliqueduplo_ticket;
int totalorders;
int totalpositions;
int arrayTickets[];
string objchange;
int chartcount;
string hline_select;
int hline_mover;
string objold;
string objnew6;
int order_type0_;
int tp_click;
int sl_click;
string _text;
int _largura;
bool prot=1;
struct Propriedades
  {
   string            order_name;
   ulong             order_ticket;
   int               order_type0;
   string            order_type;
   double            order_price;
   double            order_open;
   double            order_volume;
   string            order_symbol;
   double            order_sl;
   double            order_tp;
   double            order_sl_rr;
   double            order_tp_rr;
   string            order_comment;
   double            order_info;
  };


Propriedades virtual_lista[];
//+------------------------------------------------------------------+
