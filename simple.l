%option yylineno

%{
	int num_linea = 1;
%}

%x comentario_simple

PALABRAS_RESERVADAS (?i:auto|break|case|char|continue|default|define|do|double|else|enum|extern|float|for|goto|if|include|int|long|register|return|short|signed|static|struct|switch|typeof|union|unsigned|void|while)

IDEN [A-Za-z_][0-9A-Za-z_]*

DECIMALES [0-9]+
OCTALES 0[0-7]+
HEXADECIMALES 0[xX][0-9A-Fa-f]+

REAL ([0-9]*\.[0-9]+)|(0[xX][0-9A-Fa-f]*\.[0-9A-Fa-f]+)
DECIMAL_CON_MANTISA ([0-9]*\.?[0-9]+)[eE][+-]?[0-9]+
HEXADECIMAL_CON_MANTISA (0[xX][0-9A-Fa-f]*)\.([0-9A-Fa-f]+)[eE][+-]?[0-9A-Fa-f]+

CARACTERES_SIMPLES '[^\n'\\]'
CARACTERES_ESCAPADOS '\\['"?\\nrtv]'
CARACTERES_OCTALES '\\([1]?[0-7]{1,2})'
CARACTERES_HEXADECIMALES '\\x([0-7]?[0-9A-Fa-f])'

CADENAS_SIMPLES \".*[^"\n\\]\"
CADENAS_ESCAPADAS \"\\['"?\\nrtv]\"
CADENAS_OCTALES "\\([1]?[0-7]{1,2})"
CADENAS_HEXADECIMALES "\\x([0-7]?[0-9A-Fa-f])"

PATHS <.*>

DELIMITADORES \(|\)|\{|\}|\?|:|;|,

OPERADORES_ARITMETICOS \+\+|\-\-|\*\*|\+=|-=|\*=|\/=|%=|\+|-|\*|\/|%
OPERADORES_DE_BITS ~|&=|\|=|<<=|>>=|<<|>>|&|\^=|\|
OPERADORES_DE_ACCESO_MEMORIA \.|->|\*|&|\[|\]
OPERADORES_RELACIONALES <=|>=|<>|<|>|==
OPERADORES_LOGICOS !|&&|\|\|
OPERADORES_OTROS =|#|sizeof

COMENTARIO_SIMPLE \/\/.*
COMENTARIO_SIN_SALTO \/*([^#\n])\*\/
COMENTARIO_MULTILINEA \/\*[\x00-\x7F]*\*\/

%%

[\n] num_linea++;

{OCTALES} printf("Linea %d, esto es una constante entera octal: %s\n",num_linea,yytext);
{HEXADECIMALES} printf("Linea %d, esto es una constante entera hexadecimal: %s\n",num_linea,yytext);
{DECIMALES} printf("Linea %d, esto es una constante entera decimal: %s\n",num_linea,yytext);
{DELIMITADORES} printf("Linea %d, esto es un delimitador: %s\n",num_linea,yytext);
{OPERADORES_ARITMETICOS} printf("Linea %d, esto es un operador aritmetico: %s\n",num_linea,yytext);
{OPERADORES_DE_BITS} printf("Linea %d, esto es un operador de bits: %s\n",num_linea,yytext);
{OPERADORES_OTROS} printf("Linea %d, esto es otro tipo de operador: %s\n",num_linea,yytext);
{OPERADORES_DE_ACCESO_MEMORIA} printf("Linea %d, esto es un operador de memoria: %s\n",num_linea, yytext);
{OPERADORES_RELACIONALES} printf("Linea %d, esto es un operador relacional: %s\n",num_linea,yytext);
{OPERADORES_LOGICOS} printf("Linea %d, esto es un operador logico: %s\n",num_linea,yytext);
{PALABRAS_RESERVADAS} printf("Linea %d, esto es una palabra reservada: %s\n",num_linea,yytext);
{IDEN} printf("Linea %d, esto es un identificador: %s\n",num_linea,yytext);

{REAL} printf("Linea %d, esto es una constante real: %s\n",num_linea,yytext);
{DECIMAL_CON_MANTISA} printf("Linea %d, esto es una constante real decimal con mantisa/exponente: %s\n",num_linea,yytext);
{HEXADECIMAL_CON_MANTISA} printf("Linea %d, esto es una constante real hexadecimal con mantisa/exponente: %s\n",num_linea,yytext);

{CADENAS_SIMPLES} printf("Linea %d, esto es una cadena: %s\n",num_linea,yytext);
{CADENAS_ESCAPADAS} printf("Linea %d, esto es una cadena: %s\n",num_linea,yytext); num_linea++;
{CADENAS_OCTALES} printf("Linea %d, esto es una cadena: %s\n",num_linea,yytext); num_linea++;
{CADENAS_HEXADECIMALES} printf("Linea %d, esto es una cadena: %s\n",num_linea,yytext); num_linea++;

{CARACTERES_SIMPLES} printf("Linea %d, esto es un caracter: %s\n",num_linea,yytext);
{CARACTERES_ESCAPADOS} printf("Linea %d, esto es un caracter: %s\n",num_linea,yytext);
{CARACTERES_OCTALES} printf("Linea %d, esto es un caracter: %s\n",num_linea,yytext); 
{CARACTERES_HEXADECIMALES} printf("Linea %d, esto es un caracter: %s\n",num_linea,yytext);

{COMENTARIO_SIMPLE} printf(" ");
##{COMENTARIO_MULTILINEA} printf(" "); num_linea++;

{PATHS} printf("Linea %d, esto es un path: %s\n",num_linea,yytext);

"/*"      {yymore(); BEGIN(comentario_simple);}
<comentario_simple>[^*\n]* {yymore();}
<comentario_simple>"*"+[^*/\n]* {yymore();}
<comentario_simple>\n  {num_linea++; yymore();}
<comentario_simple>"*"+"/"  {printf(" "); BEGIN(INITIAL);}

%%

int yywrap()
{
	return 1;
}
int main(int argc,char *argv[]){

	if(argc < 2){
		printf("Uso: ./p1 prueba\n");
	}
	else{
		yyin = fopen(argv[1],"r");
		yylex();
	}
}
