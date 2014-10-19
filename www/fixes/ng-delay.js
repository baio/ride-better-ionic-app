fixes = angular.module('fixes', []);

fixes.directive('ngDelay', ['$timeout', function ($timeout) {
    return {
        restrict: 'A',
        scope:true,
        compile: function (element, attributes) {
            var expression = attributes['ngChange'];
            if (!expression)
                return;

            attributes['ngChange'] = '$$delay.execute()';
            return {
                pre: function (scope, element, attributes) {
                    scope.$$delay = {
                        expression: expression,
                        delay: scope.$eval(attributes['ngDelay']),
                        execute: function () {
                            var state = scope.$$delay;
                            state.then = Date.now();
                            $timeout(function () {
                                if (Date.now() - state.then >= state.delay)
                                    scope.$eval(expression);
                            }, state.delay);
                        }
                    };
                }
            }
        }
    };
}]);
