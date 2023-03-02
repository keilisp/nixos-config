{:user {:local-repo #=(eval (str (System/getenv "XDG_DATA_HOME") "/m2")) ;
        :repositories  {"local" {:url #=(eval (str "file://" (System/getenv "XDG_DATA_HOME") "/m2")) ; Respect XDG
                                 :releases {:checksum :ignore}}}
        :plugins [[lein-try "0.4.3"] ; try new libraries easily
                  [cider/cider-nrepl "0.29.0"]
                  [refactor-nrepl "3.5.2"]
                  [lein-ancient "1.0.0-RC3"] ; check dependencies
                  [lein-pprint "1.3.2"] ; pretty-print lein dependencies
                  [com.gfredericks/lein-shorthand "0.4.1"]
                  [mvxcvi/whidbey "2.2.1"]] ; puget nrepl middleware 
        :dependencies [[hashp "0.2.1"] ; better prn
                       [philoskim/debux "0.8.2"] ; cool debug tool
                       [lambdaisland/deep-diff2 "2.0.108"] ; diff data in a nice way
                       [expound "0.9.0"] ; improve spec error messages
                       [mvxcvi/puget "1.3.2"]] ; colour print data 
        :middleware [whidbey.plugin/repl-pprint] 
        :injections [(require '[hashp.core :refer :all])
                     (require '[debux.core :refer :all])
                     (require '[lambdaisland.deep-diff2 :as ddiff])] 
        :shorthand {. {pp clojure.pprint/pprint}}}

 :repl {:plugins []}}
