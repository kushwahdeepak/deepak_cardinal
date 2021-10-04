import isNil from 'lodash.isnil'
import isEmpty from 'lodash.isempty'

class Util {
    /**
     * Define stage values
     */
    static STAGES = ['first_interview', 'second_interview', 'offer', 'reject']

    /**
     * Tests whether a single object attribute includes the at
     * least one string from the given set.
     */
    static attributePassesStringSetFilter(object, attr, stringSet) {
        if (isNil(object[attr])) return false

        // We "OR" the tag tests: the attribute needs to contain only one tag
        return stringSet
            .map((string) => string.trim().toLowerCase())
            .reduce(
                (passes, string) =>
                    passes ||
                    Util.attributeToString(object[attr])
                        .toLowerCase()
                        .includes(string),
                false
            )
    }

    /**
     * Tests whether at least one of a set of object attributes
     * includes every word from a given piece of text.
     */
    static objectPassesTextFilter(object, attrs, text) {
        text = text.trim().toLowerCase()

        if (text === '') return true

        const words = text.split(' ')

        // Join all the given attribute names to lowercase, stringified attribute values
        const allAttrsString = attrs
            .filter((attr) => !isNil(object[attr]))
            .map((attr) => Util.attributeToString(object[attr]).toLowerCase())
            .join('')

        // Is every word included in the allAttrsString?
        return words.reduce(
            (matchesAll, word) => matchesAll && allAttrsString.includes(word),
            true
        )
    }

    static attributeToString(attr) {
        if (typeof attr === 'string') {
            return attr
        } else if (Array.isArray(attr)) {
            return attr.join(',')
        } else if (typeof attr === 'object') {
            return JSON.stringify(attr)
        } else {
            return '' + attr
        }
    }

    static numberWithCommas(x) {
        return x?.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    }

    /**
     * Returns number of results in format [x] - [y] of [z]
     * @param {number} totalJobsCount Total number of jobs
     * @param {number} pageCount Total number of pages
     * @param {number} activePage Currently active page
     * @param {number} pageSize How many results to display per page
     */
    static displayNumberOfResults(
        totalJobsCount,
        pageCount,
        activePage,
        pageSize,
        totalPersonCount=null,
        candidatePage=false,
        showdisplaycount=true
    ) {
        if (totalJobsCount == 0) return '0 - 0 of 0'
        const offset = pageSize * pageCount - totalJobsCount
        const lastJobIndex =
            (activePage + 1) * pageSize > totalJobsCount
                ? totalJobsCount
                : (activePage + 1) * pageSize
        const firstJobIndex =
            activePage == 0
                ? 1
                : activePage == pageCount - 1
                ? lastJobIndex - pageSize + offset + 1
                : lastJobIndex - pageSize + 1
        return `${firstJobIndex} - ${lastJobIndex} of ${Util.numberWithCommas(
            (candidatePage && showdisplaycount) ? totalPersonCount : totalJobsCount

        )}`
    }

    /**
     * Returns a string indicating the candidate's title and current
     * company, based on available information on the Person object
     * @param {object} candidate Person object from our db
     */
    static candidateCompanyString(candidate) {
        const position = candidate.company_position
        const currentCompany = candidate.current_company

        if (isEmpty(position) && isEmpty(currentCompany)) return ''

        if (!isEmpty(position) && !isEmpty(currentCompany))
            return `${position} at ${currentCompany}`

        if (!isEmpty(position)) return position

        if (!isEmpty(currentCompany)) return `at ${currentCompany}`
    }

    /**
     * Converts the given array of objects with ids to an object whose
     * keys are the ids of the array objects.
     *
     * Every object in the given array must have a unique 'id' property defined.
     *
     * @param {Array} array
     * @returns {Object}
     */
    static arrayToObject(array) {
        const obj = {}
        array.forEach((element) => (obj[element.id] = element))
        return obj
    }

    /**
     * Makes a copy of the given array and replace the value at 'index' with 'value'
     *
     * @param {Array} array
     * @param {Number} index
     * @param {*} value
     * @returns {Array}
     */
    static replaceInArrayCopy_i(array, index, value) {
        const clone = array.slice()
        clone[index] = value
        return clone
    }

    /**
     * Makes a copy of the given array and replaces the element with the same
     * .id property as obj.id with obj
     *
     * @param {Array} array
     * @param {Object} obj
     * @returns {Array}
     */
    static replaceInArrayCopy(array, obj) {
        const index = array.findIndex((element) => element.id === obj.id)
        return Util.replaceInArrayCopy_i(array, index, obj)
    }

    static deleteInArrayCopy(array, index) {
        const copy = array.slice()
        copy.splice(index, 1)

        return copy
    }

    static handleUndefined(value){
        if (value === undefined || value === 'undefined')
        return '';
        else
        return value
    }

    static handleUndefinedFullName(firstName, lastName){
      if(firstName === "undefined" || firstName === undefined)
      return lastName
      else if(lastName === "undefined" || lastName === undefined)
      return firstName
      else
      return firstName + ' ' + lastName     }

    static capitalize(value){
         return value.charAt(0).toUpperCase() + value.slice(1).toLowerCase();
    }
}

export default Util
