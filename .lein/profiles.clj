{:user {:plugins [[lein-ancient "0.5.4"]
                  [lein-try "0.4.1"]
                  [lein-exec "0.3.2"]
                  [compojure-app/lein-template "0.4.0"]]
        :dependencies [[cider/cider-nrepl "0.1.0-SNAPSHOT"]]
        :repl-options {:nrepl-middleware
                       [cider.nrepl.middleware.complete/wrap-complete
                        cider.nrepl.middleware.info/wrap-info
                        cider.nrepl.middleware.inspect/wrap-inspect]}}}
