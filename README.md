# Melate_aleatorio
Proyecto en GNU CLISP 2.49.93+ para estimar aleatoriedad de sorteo Melate con números coprimos.

Datos obtenidos de sorteo Melate, Revancha y revanchita.

Antes de correr el código es necesario:

- Instalar "quickslisp.lisp" para la lectura de csv.

- Cambiar ruta de quicklisp y ruta donde está el archivo csv de melate.


----------------------------------------------------------------------------------------
# Resultados
Se realizaron 100 muestras aleatorias de igual tamaño que la cantidad de sorteos analizados, para comparar el resultado. Recordando que la probabilidad de que dos números sean coprimos es
$\mathbb{P}(n, m \text{ coprimos}) = \frac{\pi ^ 2}{6} $
Es decir
$ \pi = \sqrt{\frac{6}{\mathbb{P}(n, m \text{ coprimos})}} $

Dado el análisis la estimación de $\pi$ de los números pseudoaleatorios calculando el intervalo $(\hat{p}-\hat{\sigma}, \hat{p}+ \hat{\sigma} )$ es

$$\hat{\pi}_{\text{ps}} \in  (3.100189 3.228481)$$

Mientras, las estimaciones para los sorteos no caen dentro de este intervalo

$$\begin{matrix} \hat{\pi}_{\text{melate}}&=&2.9359474 \\  \hat{\pi}_{\text{revancha}}&=& 2.9618344 \\  \hat{\pi}_{\text{revanchita}}&=& 3.0212016  \end{matrix}$$

Indicando que *no hay evidencia* de que sean *números aleatorios*.
