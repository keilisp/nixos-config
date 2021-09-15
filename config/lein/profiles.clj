{:user {:local-repo #=(eval (str (System/getenv "XDG_CACHE_HOME") "/m2"))
        :repositories  {"local" {:url #=(eval (str "file://" (System/getenv "XDG_DATA_HOME") "/m2"))
                                 :releases {:checksum :ignore}}}
        :plugins [[lein-try "0.4.3"]]}

 :repl {:plugins [[cider/cider-nrepl "0.26.0"]]}}
