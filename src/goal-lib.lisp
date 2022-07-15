(in-package :goal-lib)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstant else t)
(defun null? (val) (null val))
(defun integer? (val) (integerp val))
(defun float? (val) (floatp val))

(defconstant true t)
(defconstant false nil)

(defmacro equal? (&rest args)
  `(equalp ,@args))

(defmacro notequal? (&rest args)
  `(not (equalp ,@args)))

(defmacro == (&rest args)
  `(equalp ,@args))

(defmacro != (&rest args)
  `(not (equalp ,@args)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STRING TOOLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro string-append (&rest list)
  `(format nil "~{~a~}" (list ,@list)))

(defmacro string-append! (var &rest list)
  `(setf ,var (string-append ,var ,@list)))


(defun string-join (list &optional (delim "&"))
    (with-output-to-string (s)
        (when list
            (format s "~A" (first list))
            (dolist (element (rest list))
	      (format s "~A~A" delim element)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LIST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro list-ref (list n)
  `(nth ,n ,list))

(defun list->array (list)
  (coerce list 'vector))

(defun array->list (array)
  (coerce array 'list))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ARRAYS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun arr-new (&key (capacity 8) (element-type nil)) 
  (if element-type
      (make-array capacity :fill-pointer 0 :adjustable t :element-type element-type)
      (make-array capacity :fill-pointer 0 :adjustable t)
      ))

(defmacro arr-first (coll)
  "Returns the first element in an array"
  `(aref ,coll 0))

(defmacro arr-last (coll)
  "Returns the last element in an array"
  `(aref ,coll (dec (length ,coll))))

(defmacro arr-last-idx (coll)
  "Returns the index of the last element in an array"
  `(dec (length ,coll)))

(defmacro arr-idx-of (coll val def)
  "Returns the index of an item in an array, returns <def> if is nothing is found."
  `(block find-element
    (dotimes (i (length ,coll))
      (if (= ,val (-> ,coll i))
        (return-from find-element i)))
    ,def))

(defmacro arr-ref (col key &optional (default nil))
  `(aref ,col ,idx))

(defmacro arr-set! (col idx val)
  `(setf (aref ,col ,idx) ,val))

(defmacro arr-push (col val)
  `(vector-push ,col ,val))

(defmacro arr-count (col)
  `(length ,col))


;;;;;;;;;;;;;;;;;;;
;; Math Macros
;;;;;;;;;;;;;;;;;;;

(defmacro set! (place value)
  `(setf ,place ,value)
  )

;; (defmacro 1+ (var)
;;   `(+ ,var 1)
;;   )

(defmacro inc (val)
  "Increments a value"
  `(1+ ,val))

(defmacro +! (place amount)
  `(set! ,place (+ ,place ,amount))
  )

(defmacro 1+! (place)
  `(+! ,place 1)
  )

;; (defmacro 1- (var)
;;   `(+ ,var -1)
;;   )

(defmacro dec (val)
  "Decrements a value"
  `(1- ,val))

(defmacro -! (place amount)
  `(set! ,place (- ,place ,amount))
  )

(defmacro 1-! (place)
  `(-! ,place 1)
  )

(defmacro *! (place amount)
  `(set! ,place (* ,place ,amount))
  )

(defmacro /! (place amount)
  `(set! ,place (/ ,place ,amount))
  )

(defmacro zero? (thing)
  `(eq? ,thing 0)
  )

(defmacro nonzero? (thing)
  `(neq? ,thing 0)
  )

(defmacro or! (place &rest args)
  `(set! ,place (or ,place ,@args))
  )

(defmacro not! (var)
  `(set! ,var (not ,var)))

(defmacro true! (var)
  `(set! ,var true))

(defmacro false! (var)
  `(set! ,var false))

(defmacro minmax (val minval maxval)
  `(max (min ,val ,maxval) ,minval)
  )

(defmacro fminmax (val minval maxval)
  `(fmax (fmin ,val ,maxval) ,minval)
  )
(defmacro minmax! (val minval maxval)
  `(set! ,val (max (min ,val ,maxval) ,minval))
  )
(defmacro fminmax! (val minval maxval)
  `(set! ,val (fmax (fmin ,val ,maxval) ,minval))
  )

(defmacro maxmin (val minval maxval)
  `(min (max ,val ,maxval) ,minval)
  )

(defmacro fmaxmin (val minval maxval)
  `(fmin (fmax ,val ,maxval) ,minval)
  )

(defmacro &+! (val amount)
  `(set! ,val (&+ ,val ,amount))
  )

(defmacro &- (a b)
  `(- (the-as int ,a) (the-as int ,b))
  )

(defmacro &-> (&rest args)
  `(& (-> ,@args))
  )

(defmacro logior! (place amount)
  `(set! ,place (logior ,place ,amount))
  )

(defmacro logxor! (place amount)
  `(set! ,place (logxor ,place ,amount))
  )

(defmacro logand! (place amount)
  `(set! ,place (logand ,place ,amount))
  )

(defmacro logclear (a b)
  "Returns the result of setting the bits in b to zero in a"
  ;; put a first so the return type matches a.
  `(logand ,a (lognot ,b))
  )

(defmacro logclear! (a b)
  "Sets the bits in b to zero in a, in place"
  `(set! ,a (logand ,a (lognot ,b)))
  )

(defmacro logtest? (a b)
  "does a have any of the bits in b?"
  `(nonzero? (logand ,a ,b))
  )

(defmacro logtesta? (a b)
  "does a have ALL of the bits in b?"
  `(= (logand ,b ,a) ,b)
  )
#|
(defmacro deref (t addr &rest fields)
  `(-> (the-as (pointer ,t) ,addr) ,@fields)
  )

(defmacro &deref (t addr &rest fields)
  `(&-> (the-as (pointer ,t) ,addr) ,@fields)
  )

(defmacro shift-arith-right-32 (result in sa)
  `(set! ,result (sext32 (sar (logand #xffffffff (the-as int ,in)) ,sa)))
  )
|#
(defmacro /-0-guard (a b)
  "same as divide but returns -1 when divisor is zero (EE-like)."
  `(let ((divisor ,b))
      (if (zero? divisor)
          -1
          (/ ,a divisor))
      )
  )

(defmacro mod-0-guard (a b)
  "same as modulo but returns the dividend when divisor is zero (EE-like)."
  `(let ((divisor ,b))
      (if (zero? divisor)
          ,a
          (mod ,a divisor))
      )
  )

(defmacro float->int (a)
  "forcefully casts something as a float to int. be careful."
  `(the integer (round (the float ,a)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bit Macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro align-n (val n)
  "align val to n-byte boundaries"
  `(logand (- ,n) (+ (the-as int ,val) (- ,n 1)))
  )

(defmacro align16 (val)
  `(align-n ,val 16)
  )

(defmacro align64 (val)
  `(align-n ,val 64)
  )

(defmacro bit-field (type val base size &optional (signed t))
  "extract bits from an integer value."
  (when (and (integer? base) (integer? size))
      (when (> (+ base size) 64)
          (error "cannot extract fields across 64-bit boundaries"))
      (when (< base 0)
          (error "bitfield base cannot be negative"))
      (when (< size 0)
          (error "bitfield size cannot be negative"))
      )
  `(,(if signed 'sar 'shr) (shl ,val (- 64 (+ ,size ,base))) (- 64 ,size))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The structure helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Same as with-slots but can rename fields less verbose
;;
;; Usage:
;;
;; (defstruct v3 x y z)
;; (defvar v (make-v3 :x 10 :y 20 :z 30))
;; (my/with-slots f- (v3 x y z) v
;;    (format t "~a ~a ~a" f-x f-y f-x))
;;
;; (defun foo ()
;;    (my/with-slots foo- (v3 x y z ) (make-v3 :x 10 :y 20 :z 30)
;;      (my/with-slots bar- (v3 x y z ) (make-v3 :x 40 :y 50 :z 60)
;;        (format t "FOO x ~a y ~a z ~a~%" foo-x foo-y foo-z)
;;        (format t "BAR x ~a y ~a z ~a~%" bar-x bar-y bar-z))))
;; (foo)

(defmacro my/with-slots (prefix (struct &rest fields) obj &body body)
  (let*      
      ((symbol-list
	 (loop for f in fields
	       collect (cons
			(intern (format nil "~a~a" prefix f))
			(find-symbol (string-upcase (format nil "~a-~a" struct f))))))
       (expr-list
	 (loop for f in symbol-list
	       collect `(,(car f) (,(cdr f) ,obj)))))
    `(symbol-macrolet (,@expr-list) ,@body)))

;; Copy the structure and override some of values
;;
;; CL-USER> (defstruct foo bar baz)
;; FOO
;; CL-USER> (defparameter *first* (make-foo :bar 3))
;; *FIRST*
;; CL-USER> (defparameter *second* (update-struct *first* 'baz 2))
;; *SECOND*
;; CL-USER> (values *first* *second*)
;; #S(FOO :BAR 3 :BAZ NIL)
;; #S(FOO :BAR 3 :BAZ 2)

(defun update-struct (struct &rest bindings)
  (loop
    with copy = (copy-structure struct)
    for (slot value) on bindings by #'cddr
    do (setf (slot-value copy slot) value)
    finally (return copy)))

;; ==============================================================================
;; Hash table helpters
;; ==============================================================================

(defmacro hash-ref (hash key &optional (default nil))
  `(gethash ,key ,hash ,default))
(defmacro hash-set! (hash key val)
  `(setf (gethash ,key ,hash) ,val))
(defmacro hash-count (hash)
  `(hash-table-size ,hash))
(defmacro hash-map (hash func)
  `(maphash ,func ,hash))

;; ==============================================================================
;;
;; ==============================================================================
;; (my/defun foo (a b)
;;   (var x 2)
;;   (var y 3)
;;   (* x y a b))
;;
;; (foo 4 5)
;; ; => 120

(defun my/vardecl-p (x)
  "Return true if X is a (VAR NAME VALUE) form."
  (and (listp x)
       (> (length x) 1)
       (eq 'var (car x))))

(defmacro my/defun (name args &rest body)
  "Special form of DEFUN with a flatter format for LET vars"
  (let ((vardecls (mapcar #'cdr
                          (remove-if-not #'my/vardecl-p body)))
        (realbody (remove-if #'my/vardecl-p body)))
    `(defun ,name ,args
       (let* ,vardecls
         ,@realbody))))
