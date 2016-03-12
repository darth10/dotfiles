{:user {:plugins
        [[lein-ancient "0.6.7"]
         [lein-exec "0.3.5"]
         [lein-pprint "1.1.2"]
         [lein-try "0.4.3"]
         [http-kit/lein-template "1.0.0-SNAPSHOT"]
         [compojure-app/lein-template "0.4.7"]]}
 :repl {:plugins
        [[refactor-nrepl "2.0.0"]
         [cider/cider-nrepl "0.12.0-SNAPSHOT"]]
        :dependencies
        [[org.clojure/tools.nrepl "0.2.12"]
         [compliment "0.2.5"]]}}
