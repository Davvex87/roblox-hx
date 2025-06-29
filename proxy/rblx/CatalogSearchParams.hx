package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("CatalogSearchParams")
abstract CatalogSearchParams(CatalogSearchParamsData) {}

@:native("CatalogSearchParams")
private extern class CatalogSearchParamsData
{
	public extern function new();

	/**
	 * The keyword to search for catalog results with.
	 */
	@:native("SearchKeyword")
	public extern var searchKeyword:String;

	/**
	 * The minimum item price to search for.
	 */
	@:native("MinPrice")
	public extern var minPrice:Int;

	/**
	 * The maximum item price to search for.
	 */
	@:native("MaxPrice")
	public extern var maxPrice:Int;

	/**
	 * The order in which to sort the results.
	 */
	@:native("SortType")
	public extern var sortType:CatalogSortType;

	/**
	 * The time period to use to aggregate the sort results.
	 */
	@:native("SortAggregation")
	public extern var sortAggregation:CatalogSortAggregation;

	/**
	 * The category to filter the search by.
	 */
	@:native("CategoryFilter")
	public extern var categoryFilter:CatalogCategoryFilter;

	/**
	 * The sales type filter the search by.
	 */
	@:native("SalesTypeFilter")
	public extern var salesTypeFilter:SalesTypeFilter;

	/**
	 * An array containing Enum.BundleType values to filter the search by.
	 */
	@:native("BundleTypes")
	public extern var bundleTypes:Array<BundleType>;

	/**
	 * An array containing Enum.AvatarAssetType values to filter the search by.
	 */
	@:native("AssetTypes")
	public extern var assetTypes:Array<AvatarAssetType>;

	/**
	 * Whether off sale items should be included in the results.
	 */
	@:native("IncludeOffSale")
	public extern var includeOffSale:Bool;

	/**
	 * Search for items with the given creator name.
	 */
	@:native("CreatorName")
	public extern var creatorName:String;

	/**
	 * Search for items created by the given creator type.
	 */
	@:native("CreatorType")
	public extern var creatorType:CreatorTypeFilter;

	/**
	 * Search for items created by the given creator ID.
	 */
	@:native("CreatorId")
	public extern var creatorId:Int;

	/**
	 * Specifies the number of items to return. Accepts 10, 28, 30, 60, and 120. Defaults to 30.
	 */
	@:native("Limit")
	public extern var limit:Int;
}
