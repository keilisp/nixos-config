{:user {:local-repo #=(eval (str (System/getenv "XDG_CACHE_HOME") "/m2"))
        :repositories  {"local" {:url #=(eval (str "file://" (System/getenv "XDG_DATA_HOME") "/m2"))
                                 :releases {:checksum :ignore}}}
        :plugins [[lein-try "0.4.3"]
                  [cider/cider-nrepl "0.27.2"]
                  [refactor-nrepl "3.0.0-alpha13"]
                  [lein-ancient "1.0.0-RC3"]
                  [lein-pprint "1.3.2"]]}

 :repl {:plugins []}}
