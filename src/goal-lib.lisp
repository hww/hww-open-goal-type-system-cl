(in-package :type-system)

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
  `(equal ,@args))

(defmacro == (&rest args)
  `(equal ,@args))

(defmacro != (&rest args)
  `(not (equal ,@args)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STRING TOOLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun string-append (&rest list)
  (format nil "~{~a~}" list))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LIST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro list-ref (list n)
  `(nth ,list ,n))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ARRAYS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro first-arr (coll)
  "Returns the first element in an array"
  `(aref ,coll 0))

(defmacro last-arr (coll)
  "Returns the last element in an array"
  `(aref ,coll (dec (length ,coll))))

(defmacro last-idx-arr (coll)
  "Returns the index of the last element in an array"
  `(dec (length ,coll)))

(defmacro arr-idx-of (coll val def)
  "Returns the index of an item in an array, returns <def> if is nothing is found."
  `(block find-element
    (dotimes (i (length ,coll))
      (if (= ,val (-> ,coll i))
        (return-from find-element i)))
    ,def))

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
