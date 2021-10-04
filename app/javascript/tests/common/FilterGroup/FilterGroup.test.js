import React from 'react';
import FilterGroup from '../../../components/common/FilterGroup/FilterGroup';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<FilterGroup {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<FilterGroup {...props}/>);
};

const initialProps = {
	filterCount: 2
};

describe('FilterGroup component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			...initialProps
		};

		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper && fullWrapper.unmount();
	});

	it('should render FilterGroup component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<FilterGroup />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('FilterGroup component with props', () => {
		let wrapper;
		let fullWrapper;

		beforeEach(() => {

			const props = {
				...initialProps
			};

			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		it('should render Active Span', () => {
			const span = findByTestAttr(fullWrapper, 'filters-active-span');
			expect(span.length).toBe(1);
		});

		it('should render the correct span text', () => {
			const span = findByTestAttr(fullWrapper, 'filters-active-span');
			expect(span.text()).toBe(`${initialProps.filterCount} filters active`);
		});

		it('should have the correct styles for Card Header', () => {
			const CardHeader = findByTestAttr(fullWrapper, 'filters-card-header').at(0);
			expect(CardHeader.prop('style')).toHaveProperty('color', '#6c6ce0');
		});

		it(`should have the correct length of children on CardHeader`, () => {
			const cardHeader = findByTestAttr(fullWrapper, 'filters-card-header').at(1);
			expect(cardHeader.children().length).toBe(2);
		});
	});
	describe('FilterGroup component without props', () => {
		let wrapper;
		let fullWrapper;

		beforeEach(() => {
			wrapper = initialShallowRender();
			fullWrapper = initialMountRender();
		});

		it(`shouldn't render Active Span`, () => {
			const span = findByTestAttr(fullWrapper, 'filters-active-span');
			expect(span.length).toBe(0);
		});
		it(`should have the correct length of children on CardHeader`, () => {
			const cardHeader = findByTestAttr(fullWrapper, 'filters-card-header').at(1);
			expect(cardHeader.children().length).toBe(1);
		});
	});

});
