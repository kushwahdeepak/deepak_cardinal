import React from 'react';
import Paginator from '../../../components/common/Paginator/Paginator';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<Paginator {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<Paginator {...props}/>);
};

const calcVisibleItemRange = jest.fn();

describe('Paginator component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {
		const mockCallBack = jest.fn();

		const props = {
			pageCount: 10, pageWindowSize: 5, activePage: 1, setActivePage: mockCallBack
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render Paginator component', () => {
		expect(wrapper.exists()).toBe(true);
	});
	it('should match with a snapshot', () => {
		const component = renderer.create(<Paginator />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});
	it('should contain the root Pagination tag', () => {
		expect(wrapper.prop('data-test')).toBe('pagination');
	});
	it.skip('should get correct rangeStart and rangeEnd', () => {
		const { rangeStart, rangeEnd } = calcVisibleItemRange();
		expect(rangeStart).toBe(0);
		expect(rangeEnd).toBe(4);
	});
	it('should contain the correct number of children', () => {
		expect(wrapper.children().length).toBe(8);
		wrapper.setProps({ pageWindowSize: 10, pageCount: 20 });
		expect(wrapper.children().length).toBe(13);
	});
	it('should call LastPage button', () => {
		const lastPageBtn = findByTestAttr(fullWrapper, 'last-page-btn').at(0);
		lastPageBtn.find('a').simulate('click');
		expect(fullWrapper.props().setActivePage).toHaveBeenCalledTimes(1);
	});
	it('should call FirstPage button', () => {
		const firstPageBtn = findByTestAttr(fullWrapper, 'first-page-btn').at(0);
		firstPageBtn.find('a').simulate('click');
		expect(fullWrapper.props().setActivePage).toHaveBeenCalledTimes(1);
	});
	it('should have correct prop values', () => {
		expect(fullWrapper.props().pageCount).toEqual(10);
		expect(fullWrapper.props().pageWindowSize).toEqual(5);
		expect(fullWrapper.props().activePage).toEqual(1);
	});
	it('should call FirstPage button with correct arguments', () => {
		const firstPageBtn = findByTestAttr(fullWrapper, 'first-page-btn').first();
		const firstPageIndex = 0;
		firstPageBtn.find('a').simulate('click');
		expect(fullWrapper.props().setActivePage).toHaveBeenCalledWith(firstPageIndex);
	});

	it('should call LastPage button with correct arguments', () => {
		const lastPageBtn = findByTestAttr(fullWrapper, 'last-page-btn').first();
		const lastPageIndex = fullWrapper.props().pageCount - 1;
		lastPageBtn.find('a').simulate('click');
		expect(fullWrapper.props().setActivePage).toHaveBeenCalledWith(lastPageIndex);
		// wrapper.update();
		// expect(lastPageBtn.hasClass('active')).toBe(true);
		//
		// expect(wrapper.props().activePage).toEqual(10);
	});
	describe('Paginator items', () => {
		let wrapper;
		let fullWrapper;

		beforeEach(() => {
			const mockCallBack = jest.fn();

			const props = {
				pageCount: 10, pageWindowSize: 5, activePage: 1, setActivePage: mockCallBack
			};
			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		afterEach(() => {
			fullWrapper.unmount();
		});

		it('should have active class after click', () => {
			const lastPageIndex = fullWrapper.props().pageCount - 1;
			fullWrapper.setProps({ activePage: lastPageIndex });
			fullWrapper.update();
			expect(findByTestAttr(findByTestAttr(fullWrapper, 'pagination').first(), 'last-page-btn').first().childAt(0).hasClass('active')).toBe(true);
		});
	});

});
