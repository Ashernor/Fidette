// Generated by CoffeeScript 1.3.3
(function() {
  var DateRange, moment;

  moment = typeof require !== "undefined" && require !== null ? require("moment") : this.moment;

  /**
   * DateRange class to store ranges and query dates.
   * @typedef {!Object}
   *
   */


  DateRange = (function() {
    /**
     * DateRange instance.
     * @param {(Moment|Date)} start Start of interval.
     * @param {(Moment|Date)} end   End of interval.
     * @constructor
     *
     */

    function DateRange(start, end) {
      this.start = start;
      this.end = end;
    }

    /**
     * Determine if the current interval contains a given moment/date.
     * @param {(Moment|Date)} moment Date to check.
     * @return {!boolean}
     *
     */


    DateRange.prototype.contains = function(moment) {
      return (this.start < moment && moment < this.end);
    };

    /**
     * Iterate over the date range by a given date range, executing a function
     * for each sub-range.
     * @param {!DateRange|String}        range     Date range to be used for iteration or shorthand string (shorthands: http://momentjs.com/docs/#/manipulating/add/)
     * @param {!function(Moment)} hollaback Function to execute for each sub-range.
     * @return {!boolean}
     *
     */


    DateRange.prototype.by = function(range, hollaback) {
      var end, i, l, start, _i;
      if (typeof range === 'string') {
        start = moment();
        end = moment(start).add(range, 1);
        range = moment().range(start, end);
      }
      l = Math.round(this / range);
      for (i = _i = 0; 0 <= l ? _i <= l : _i >= l; i = 0 <= l ? ++_i : --_i) {
        hollaback.call(this, moment(this.start.valueOf() + range.valueOf() * i));
      }
      return this;
    };

    /**
     * Date range in milliseconds. Allows basic coercion math of date ranges.
     * @return {!number}
     *
     */


    DateRange.prototype.valueOf = function() {
      return this.end - this.start;
    };

    return DateRange;

  })();

  /**
   * Build a date range.
   * @param {(Moment|Date)} start Start of range.
   * @param {(Moment|Date)} end   End of range.
   * @this {Moment}
   * @return {!DateRange}
   *
   */


  moment.fn.range = function(start, end) {
    return new DateRange(start, end);
  };

  /**
   * Check if the current moment is within a given date range.
   * @param {!DateRange} range Date range to check.
   * @this {Moment}
   * @return {!boolean}
   *
   */


  moment.fn.within = function(range) {
    return range.contains(this._d);
  };

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = moment;
  }

}).call(this);