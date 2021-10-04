import React from 'react';
import TagList from '../../../components/common/TagList/TagList';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';
import { nanoid } from "nanoid";

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<TagList {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<TagList {...props}/>);
};
const mockF = jest.fn().mockReturnValue('12345789');

const mappedTags = [
	{id: mockF(), value: 'test'},
	{id: mockF(), value: 'mock'},
	{id: mockF(), value: 'mockTest'}
];

const mapTagsList = jest.fn().mockReturnValue(mappedTags);

describe('TagList component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render TagList component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<TagList />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});


	describe('TagList component with props', () => {
		let wrapper;
		let fullWrapper;

		beforeEach(() => {

			const props = {
				tags: ['test', 'mock', 'mockTest'],
				maxTags: 1,
				removeTagFunc: jest.fn()
			};
			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		afterEach(() => {
			fullWrapper.unmount();
		});

		it('should render TruncatedBlock', () => {
			const component = findByTestAttr(wrapper, 'truncated-block');
			expect(component.length).toBe(1);
		});

		it("shouldn't render TruncatedBlock", () => {
			wrapper.setProps({maxTags: 3});
			const component = findByTestAttr(wrapper, 'truncated-block');
			expect(component.length).toBe(0);
		});

		it('should render RemoveButton', () => {
			const component = findByTestAttr(wrapper, 'remove-button');
			expect(component.length).toBe(1);
		});

		it('should call Remove Tag Function button', () => {
			const removeButton = findByTestAttr(fullWrapper, 'remove-button');
			removeButton.simulate('click');
			expect(fullWrapper.props().removeTagFunc).toHaveBeenCalledTimes(1);
		});

		it.skip('should call Map Tag List function', () => {
			expect(mapTagsList).toHaveBeenCalledTimes(1);
		});

		it('should have correct mapped tags', () => {
			const tagsAfterMapping = mapTagsList();
			expect(tagsAfterMapping).toEqual(mappedTags);
		});

		it('should have correct correct number of tag items', () => {
			const tagNodes = findByTestAttr(wrapper, 'tag-item');
			expect(tagNodes.length).toBe(1);
			wrapper.setProps({maxTags: 3});
			const tagNodesAfterUpdate = findByTestAttr(wrapper, 'tag-item');
			expect(tagNodesAfterUpdate.length).toBe(3);
		});

	});
	describe('TagList component without props', () => {
		it("shouldn't render RemoveButton", () => {
			const component = findByTestAttr(wrapper, 'remove-button');
			expect(component.length).toBe(0);
		});

		it('should have correct correct number of tag items', () => {
			const tagNodes = findByTestAttr(wrapper, 'tag-item');
			expect(tagNodes.length).toBe(0);
		});
	});

});
