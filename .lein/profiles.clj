{:user {:plugins [[lein-ritz "0.7.0"]
                  [lein-ancient "0.5.0-RC1"]
                  [compojure-app/lein-template "0.2.7"]]
        :dependencies [[ritz/ritz-nrepl-middleware "0.7.0"]]
        :repl-options {:nrepl-middleware
                       [ritz.nrepl.middleware.javadoc/wrap-javadoc
                        ritz.nrepl.middleware.simple-complete/wrap-simple-complete]}}}
