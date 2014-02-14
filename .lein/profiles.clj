{:user {:plugins [[lein-ancient "0.5.0-RC1"]
                  [compojure-app/lein-template "0.2.7"]]
        :dependencies [[cider/cider-nrepl "0.1.0-SNAPSHOT"]]
        :repl-options {:nrepl-middleware
                       [cider.nrepl.middleware.doc/wrap-doc
                        cider.nrepl.middleware.complete/wrap-complete
                        cider.nrepl.middleware.info/wrap-info]}}}
