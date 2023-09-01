;;;; ES NECESARIO INSTALAR QUICKLISP antes;;;;;
(load #P"[ruta-quicklisp]/quicklisp/setup.lisp") ;; Cambiar [ruta-quicklisp] por tu ruta de instalación a quicklisp

(defpackage "TAM" (:use "COMMON-LISP" "EXT" "SYSTEM" "QL")
            (:export "DATOS_SORTEO" "MY_TEST_RAND" "PRUEBA_TEST" "TEST_MELATE"))

(in-package TAM)




(ql:quickload :cl-csv) ;; SE UTILIZARÄ LA LECTURA DE DATOS CSV

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Para este caso, cargamos solo el resultado de la primera bola. Queremos
; ver si es aleatoria la elección por medio de un test (aproximando pi).
; Descartamos los demás casos ya que están condicionados al primer número
; elegido en el sorteo.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun datos_sorteo (sorteo)  
      (let ((path (make-pathname :directory
				     #P"[ruta-melate]" ;Cambiar [ruta-melate] por ruta csv de sorteo melate
				 :name sorteo :type "csv"))
	    (datos NIL))
	    (setf sort (cl-csv:read-csv path))
	    datos
	    (do ((i 1 (1+ i))) ((>= i (length sort)))
	        (setf datos (append datos (list (parse-integer (nth 0 (nth i sort)))))))
	    datos))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; El test aleatorio se basa en la probabilidad de que obtengamos primos relativos
; al azar. Entonces sqrt(6/P) debería aproximarse a pi.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my_test_rand (datos)
  (let ((p 0) (n (length datos)))
       (dotimes (i (- (floor (/ n 2)) 1))
                (let ((x1 (nth (* i 2) datos)) (x2 (nth (1+ (* i 2)) datos)))
	             (if (equal (gcd x1 x2) 1) (setf p (1+ p)))))
       (setf p (sqrt (/ 6.0 (/ p (floor (/ n 2))))))
       p))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta función hará m pruebas con series de n datos "aleatorios" (en este caso
; semialeatorios creados por CLISP) entre 1 y el limite
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun prueba_test (m n limite)
       (let ((aprox))
            (dotimes (i m)
                  (let ((datos NIL)) 
                      (dotimes (j n)
                            (setf datos (append datos 
                                        (list (random limite)))))
                      (setf aprox (append aprox (list (my_test_rand datos))))))
	     aprox))

                     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hacemos el test comparando con promedio de 100 randoms
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; necesitamos promedio y desviacion
(defun average (datos)
       (/ (apply #'+ datos) (length datos)))


(defun std (datos)
       (let ((m (average datos)) (desv 0) (n (length datos)))
            (do ((i 0 (1+ i))) ((>= i n))
                (setf desv (+ desv (expt (- (nth i datos) m) 2))))
            (expt (/ desv (- n 1)) 0.5)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; APLICAMOS EL TEST Y COMPARAMOS
(defun TEST_MELATE ()
       (let* ((melate (datos_sorteo "Melate")) 
            (revancha (datos_sorteo "Revancha"))
            (revanchita (datos_sorteo "Revanchita"))
            (aleatorio (prueba_test 100 (length melate) 56))
            (resultado nil))
            (let ((m (average aleatorio)) (desv (std aleatorio)))
                 (setf resultado (list (cons "Pi_Melate" (my_test_rand melate))
                                       (cons "Pi_Revancha" (my_test_rand revancha))
                                       (cons "Pi_Revanchita" (my_test_rand revanchita))
                                       (cons "Prom_pi_aleatorio" (list (- m (* 2 desv)) (+ m (* 2 desv)))))))
            resultado))
            

